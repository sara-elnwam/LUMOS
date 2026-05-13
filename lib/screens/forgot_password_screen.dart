// lib/screens/forgot_password_screen.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart'

    show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector, AppStrings;
import 'verify_code_screen.dart';
const _orange = Color(0xFFF27F0D);
const _txtW = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);
const _errorC = Color(0xFFEF4444);
const _successC = Color(0xFF22C55E);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  String? _error;
  bool _isLoading = false;
  bool _isSuccess = false;
  String _successMessage = '';

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final ShakeDetector _shake;

  // Voice flow variables
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
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;
    await _speak(AppStrings.get(p.langCode, 'forgot_password_instruction'));
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
    await _speak(AppStrings.get(p.langCode, 'prompt_say_field_email'));
    await Future.delayed(const Duration(milliseconds: 800));
    await LumosVoiceService.instance.startListening(
      lang: p.langCode,
      onPartial: _onPartialResult,
      onFinal: _onFinalResult,
    );
    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(seconds: 20), () {
      if (mounted && _isRecording) {
        _stopRecordingAndProcess();
      }
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
    if (_isRecording) {
      _stopRecordingAndProcess();
    }
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
        _emailCtrl.text = finalText;
        _error = null;
        _awaitConfirm = true;
      });
      _speak(AppStrings.fill(context.read<LocaleProvider>().langCode, 'prompt_confirm_entry_email', {'value': finalText}));
    } else {
      _speak(AppStrings.get(context.read<LocaleProvider>().langCode, 'prompt_heard_nothing'));
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && !_awaitConfirm) {
          _speakInstructions();
        }
      });
    }
  }

  Future<void> _confirmCurrent() async {
    if (!_awaitConfirm || !mounted) return;
    await LumosHaptics.tick();
    setState(() => _awaitConfirm = false);
    _sendResetLink();
  }

  Future<void> _redoCurrent() async {
    if (!_awaitConfirm || !mounted) return;
    await LumosHaptics.heartbeat();
    setState(() {
      _emailCtrl.text = '';
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

  // ==================== API CALL ====================

  Future<void> _sendResetLink() async {
    final p = context.read<LocaleProvider>();
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      setState(() {
        _error = AppStrings.get(p.langCode, 'enter_email');
      });
      await _speak(_error!);
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _error = AppStrings.get(p.langCode, 'invalid_email_format');
      });
      await _speak(_error!);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _isSuccess = false;
    });

    try {
      final response = await http.post(
        Uri.parse('http://lumos-api.runasp.net/api/Account/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _isLoading = false);
        await _speak(AppStrings.get(p.langCode, 'code_sent_to_email'));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(email: email),
            ),
          );
        }
      } else {
        String errorMsg = AppStrings.get(p.langCode, 'api_error');
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            errorMsg = errorData['message'];
          }
        } catch (e) {}
        setState(() {
          _isLoading = false;
          _error = errorMsg;
        });
        await _speak(errorMsg);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = AppStrings.get(p.langCode, 'network_error');
      });
      await _speak(_error!);
    }
  }
  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0A07),
        resizeToAvoidBottomInset: true,
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onTap: () {
              if (_awaitConfirm) _confirmCurrent();
            },
            onDoubleTap: () {
              if (_awaitConfirm) _redoCurrent();
            },
            onLongPressStart: (_) {
              if (p.isVoiceMode && !p.voiceDisabled && !_awaitConfirm && !_isRecording && !_isSuccess) {
                _onHoldStart();
              }
            },
            onLongPressEnd: (_) {},
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/lumos_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.bottomCenter,
                          radius: 1.4,
                          colors: [Color(0xFF3D1A00), Color(0xFF0D0A07)],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.20),
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),
                // Main Content
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 40),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF393535).withOpacity(0.25),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF2F2F2).withOpacity(0.03),
                            blurRadius: 22,
                            spreadRadius: -4,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 22,
                            spreadRadius: -4,
                            offset: const Offset(10, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                p.isRTL ? Icons.arrow_forward : Icons.arrow_back,
                                color: _txtGray,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Center(
                            child: Text(
                              AppStrings.get(p.langCode, 'forgot_password_title'),
                              style: const TextStyle(
                                color: _orange,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.75,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              AppStrings.get(p.langCode, 'forgot_password_subtitle'),
                              style: TextStyle(
                                color: _txtGray,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Email Field
                          Text(
                            AppStrings.get(p.langCode, 'email'),
                            style: const TextStyle(
                              color: _txtGray,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onLongPressStart: p.isVoiceMode && !p.voiceDisabled && !_awaitConfirm && !_isSuccess
                                ? (_) => _onHoldStart()
                                : null,
                            onLongPressEnd: (_) {},
                            child: _GlassField(
                              controller: _emailCtrl,
                              hint: AppStrings.get(p.langCode, 'enter_email'),
                              isRecording: _isRecording,
                              isActive: _awaitConfirm,
                              hasError: _error != null,
                              keyboard: TextInputType.emailAddress,
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: const TextStyle(color: _errorC, fontSize: 12),
                            ),
                          ],
                          if (_isSuccess) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _successC.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _successC.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: _successC, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _successMessage,
                                      style: TextStyle(color: _successC, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          // Send Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: (_isLoading || _isSuccess) ? null : _sendResetLink,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: _orange.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : Text(
                                AppStrings.get(p.langCode, 'send_reset_link'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Back to Sign In
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                AppStrings.get(p.langCode, 'back_to_sign_in'),
                                style: TextStyle(
                                  color: _txtGray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(color: Colors.black.withOpacity(0.35)),
                  ),
                if (p.isVoiceMode && !p.voiceDisabled && _isRecording)
                  Positioned(
                    bottom: 48,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: _orange.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.mic, color: _orange, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            AppStrings.get(p.langCode, 'tts_listening'),
                            style: const TextStyle(
                              color: _txtW,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

// ==================== GLASS FIELD WIDGET ====================

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isRecording, isActive, hasError;
  final TextInputType keyboard;

  const _GlassField({
    required this.controller,
    required this.hint,
    this.isRecording = false,
    this.isActive = false,
    this.hasError = false,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isRecording
        ? Colors.greenAccent
        : hasError
        ? _errorC
        : isActive
        ? _orange
        : _orange.withOpacity(0.25);
    final borderWidth = (isActive || isRecording) ? 2.0 : 0.8;
    final bgColor = const Color(0xFF1A110A).withOpacity(0.35);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              style: const TextStyle(color: _txtW, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: _txtGray, fontSize: 15),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              ),
            ),
          ),
          if (isRecording)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _PulsingMic(),
            ),
        ],
      ),
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
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Icon(
        Icons.mic,
        color: Colors.greenAccent.withOpacity(_anim.value),
        size: 20,
      ),
    );
  }
}