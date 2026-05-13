// lib/screens/verify_code_screen.dart
// ════════════════════════════════════════════════════════════════════════════
//  VERIFY CODE SCREEN — بعد ما المستخدم يستلم الكود على الإيميل
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'
    show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector, AppStrings;
import 'package:lumos/screens/reset_password_screen.dart'; // Ensure this path is correct
const _orange = Color(0xFFF27F0D);
const _txtW = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);
const _errorC = Color(0xFFEF4444);

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeCtrl = TextEditingController();
  String? _error;
  bool _isLoading = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final ShakeDetector _shake;

  bool _isRecording = false;
  bool _awaitConfirm = false;
  String _currentPartialText = '';
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _shake = ShakeDetector(onShake: _onShake);
    _shake.start();
    _speakInstructions();
  }

  @override
  void dispose() {
    _shake.stop();
    _anim.dispose();
    _recordingTimer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;
    await _speak(AppStrings.get(p.langCode, 'verify_code_instruction'));
  }

  Future<void> _onHoldStart() async {
    if (!mounted || _isRecording || _awaitConfirm) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;

    setState(() {
      _isRecording = true;
      _awaitConfirm = false;
      _currentPartialText = '';
      _error = null;
    });

    await LumosHaptics.heartbeat();
    await _speak(AppStrings.get(p.langCode, 'prompt_say_code'));
    await Future.delayed(const Duration(milliseconds: 800));
    await LumosVoiceService.instance.startListening(
      lang: p.langCode,
      onPartial: _onPartialResult,
      onFinal: _onFinalResult,
    );
    _recordingTimer = Timer(const Duration(seconds: 20), () {
      if (mounted && _isRecording) _stopRecordingAndProcess();
    });
  }

  void _onPartialResult(String partial) {
    if (!mounted) return;
    _currentPartialText = partial;
    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isRecording && _currentPartialText.isNotEmpty) {
        _stopRecordingAndProcess();
      }
    });
  }

  void _onFinalResult(String finalText) {
    if (!mounted) return;
    if (_isRecording) _stopRecordingAndProcess();
  }

  Future<void> _stopRecordingAndProcess() async {
    if (!_isRecording) return;
    _recordingTimer?.cancel();
    final text = await LumosVoiceService.instance.stopListening();
    if (!mounted) return;
    setState(() => _isRecording = false);
    final finalText = text.trim().isNotEmpty ? text.trim() : _currentPartialText.trim();
    if (finalText.isNotEmpty) {
      setState(() {
        _codeCtrl.text = finalText;
        _error = null;
        _awaitConfirm = true;
      });
      _speak(AppStrings.fill(context.read<LocaleProvider>().langCode,
          'prompt_confirm_code', {'value': finalText}));
    } else {
      _speak(AppStrings.get(context.read<LocaleProvider>().langCode, 'prompt_heard_nothing'));
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && !_awaitConfirm) _speakInstructions();
      });
    }
  }

  Future<void> _confirmCurrent() async {
    if (!_awaitConfirm || !mounted) return;
    await LumosHaptics.tick();
    setState(() => _awaitConfirm = false);
    _verifyCode();
  }

  Future<void> _redoCurrent() async {
    if (!_awaitConfirm || !mounted) return;
    await LumosHaptics.heartbeat();
    setState(() {
      _codeCtrl.text = '';
      _awaitConfirm = false;
      _currentPartialText = '';
      _error = null;
    });
    _onHoldStart();
  }

  Future<void> _onShake() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled || _isRecording || _awaitConfirm) return;
    await _onHoldStart();
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    if (!p.voiceDisabled) {
      await LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
    }
  }

  void _verifyCode() {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _error = AppStrings.get(context.read<LocaleProvider>().langCode, 'enter_code'));
      _speak(_error!);
      return;
    }
    if (code.length != 6) {
      setState(() => _error = AppStrings.get(context.read<LocaleProvider>().langCode, 'invalid_code_length'));
      _speak(_error!);
      return;
    }
    // انتقل إلى شاشة reset-password مع الإيميل والكود
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(email: widget.email, token: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0A07),
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onTap: () { if (_awaitConfirm) _confirmCurrent(); },
            onDoubleTap: () { if (_awaitConfirm) _redoCurrent(); },
            onLongPressStart: (_) {
              if (p.isVoiceMode && !p.voiceDisabled && !_awaitConfirm && !_isRecording) {
                _onHoldStart();
              }
            },
            child: Stack(
              children: [
                // Background (نفس الـ Glass Card)
                Positioned.fill(
                  child: Image.asset('assets/images/lumos_background.png', fit: BoxFit.cover),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 40),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF393535).withOpacity(0.25)),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      child: Column(
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(p.isRTL ? Icons.arrow_forward : Icons.arrow_back,
                                    color: _txtGray, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(AppStrings.get(p.langCode, 'verify_code_title'),
                              style: const TextStyle(color: _orange, fontSize: 28, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          Text(AppStrings.fill(p.langCode, 'verify_code_subtitle', {'email': widget.email}),
                              style: TextStyle(color: _txtGray, fontSize: 14), textAlign: TextAlign.center),
                          const SizedBox(height: 32),
                          Text(AppStrings.get(p.langCode, 'verification_code'),
                              style: const TextStyle(color: _txtGray, fontSize: 14)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onLongPressStart: (_) => _onHoldStart(),
                            child: _GlassField(
                              controller: _codeCtrl,
                              hint: AppStrings.get(p.langCode, 'enter_code'),
                              isRecording: _isRecording,
                              isActive: _awaitConfirm,
                              hasError: _error != null,
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(_error!, style: const TextStyle(color: _errorC, fontSize: 12)),
                          ],
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity, height: 48,
                            child: ElevatedButton(
                              onPressed: _verifyCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(AppStrings.get(p.langCode, 'verify_button'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (p.isVoiceMode && !p.voiceDisabled && _isRecording)
                  Positioned(
                    bottom: 48, left: 20, right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.mic, color: _orange, size: 18),
                        const SizedBox(width: 10),
                        Text(AppStrings.get(p.langCode, 'tts_listening'),
                            style: const TextStyle(color: _txtW, fontSize: 13)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== GLASS FIELD ====================
class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isRecording, isActive, hasError;
  const _GlassField({required this.controller, required this.hint, this.isRecording = false, this.isActive = false, this.hasError = false});

  @override
  Widget build(BuildContext context) {
    final borderColor = isRecording ? Colors.greenAccent : hasError ? _errorC : isActive ? _orange : _orange.withOpacity(0.25);
    final borderWidth = (isActive || isRecording) ? 2.0 : 0.8;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A110A).withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(children: [
        Expanded(child: TextField(controller: controller, style: const TextStyle(color: _txtW),
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: _txtGray),
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16)))),
        if (isRecording) Padding(padding: const EdgeInsets.only(right: 12), child: _PulsingMic()),
      ]),
    );
  }
}
class _PulsingMic extends StatefulWidget {
  const _PulsingMic();
  @override
  State<_PulsingMic> createState() => _PulsingMicState();
}
class _PulsingMicState extends State<_PulsingMic> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _ctrl, builder: (_, __) => Icon(Icons.mic, color: Colors.greenAccent.withOpacity(_ctrl.value), size: 20));
}