// lib/screens/change_password_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider, LumosVoiceService, LumosHaptics, AppStrings;
import '../services/medical_api_service.dart';

const _orange = Color(0xFFF27F0D);
const _txtW = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);
const _errorC = Color(0xFFEF4444);
const _successC = Color(0xFF22C55E);

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  String? _error;
  bool _isLoading = false;
  bool _isSuccess = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;

  int _currentStep = 0;
  bool _isVoiceMode = false;
  bool _isRecording = false;
  bool _awaitingConfirm = false;
  String _currentPartialText = '';
  Timer? _recordingTimer;
  Timer? _returnTimer;

  final List<Map<String, dynamic>> _fields = [
    {'label': 'current_password', 'hint': 'enter_current_password', 'ctrl': null},
    {'label': 'new_password', 'hint': 'enter_new_password', 'ctrl': null},
    {'label': 'confirm_password', 'hint': 'confirm_new_password', 'ctrl': null},
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();

    _fields[0]['ctrl'] = _currentCtrl;
    _fields[1]['ctrl'] = _newCtrl;
    _fields[2]['ctrl'] = _confirmCtrl;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && context.read<LocaleProvider>().isVoiceMode) {
        _startVoiceFlow();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _recordingTimer?.cancel();
    _returnTimer?.cancel();
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _startVoiceFlow() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;
    setState(() => _isVoiceMode = true);
    await _speak(AppStrings.get(p.langCode, 'change_password_instruction'));
    await Future.delayed(const Duration(milliseconds: 500));
    _promptField(0);
  }

  void _promptField(int step) async {
    if (!mounted || !_isVoiceMode) return;
    final p = context.read<LocaleProvider>();
    setState(() {
      _currentStep = step;
      _awaitingConfirm = false;
      _isRecording = false;
    });

    final label = AppStrings.get(p.langCode, _fields[step]['label']);
    final msg = AppStrings.fill(p.langCode, 'prompt_enter_field', {'field': label});
    await _speak(msg);
  }

  Future<void> _startRecording() async {
    if (!_isVoiceMode || _awaitingConfirm || _isRecording) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;

    setState(() {
      _isRecording = true;
      _currentPartialText = '';
    });

    await LumosHaptics.heartbeat();
    final label = AppStrings.get(p.langCode, _fields[_currentStep]['label']);
    await _speak(AppStrings.fill(p.langCode, 'prompt_say_field', {'field': label}));

    await Future.delayed(const Duration(milliseconds: 500));
    await LumosVoiceService.instance.startListening(
      lang: p.langCode,
      onPartial: _onPartialResult,
      onFinal: _onFinalResult,
    );

    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(seconds: 15), () {
      if (mounted && _isRecording) _stopRecordingAndProcess();
    });
  }

  void _onPartialResult(String partial) {
    if (!mounted || !_isRecording) return;
    _currentPartialText = partial;
    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(seconds: 2), () {
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

    final p = context.read<LocaleProvider>();
    setState(() => _isRecording = false);

    final finalText = text.trim().isNotEmpty ? text.trim() : _currentPartialText.trim();

    if (finalText.isNotEmpty) {
      final ctrl = _fields[_currentStep]['ctrl'] as TextEditingController;
      setState(() {
        ctrl.text = finalText;
        _error = null;
        _awaitingConfirm = true;
      });
      final readBack = finalText.length > 3 ? '••••••' : finalText;
      await _speak(AppStrings.fill(p.langCode, 'prompt_confirm_entry', {'value': readBack}));
    } else {
      await _speak(AppStrings.get(p.langCode, 'prompt_heard_nothing'));
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && _isVoiceMode && !_awaitingConfirm) {
          _promptField(_currentStep);
        }
      });
    }
  }

  Future<void> _confirmCurrent() async {
    if (!_awaitingConfirm || !_isVoiceMode || !mounted) return;
    await LumosHaptics.tick();
    setState(() => _awaitingConfirm = false);

    if (_currentStep < 2) {
      _promptField(_currentStep + 1);
    } else {
      _validateAndSubmit();
    }
  }

  Future<void> _redoCurrent() async {
    if (!_awaitingConfirm || !_isVoiceMode || !mounted) return;
    await LumosHaptics.heartbeat();
    final ctrl = _fields[_currentStep]['ctrl'] as TextEditingController;
    setState(() {
      ctrl.text = '';
      _awaitingConfirm = false;
      _currentPartialText = '';
    });
    await _speak(AppStrings.get(context.read<LocaleProvider>().langCode, 'prompt_try_again'));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isVoiceMode) _startRecording();
    });
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    if (!p.voiceDisabled) {
      await LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
    }
  }

  void _validateAndSubmit() async {
    final p = context.read<LocaleProvider>();
    final current = _currentCtrl.text.trim();
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (current.isEmpty) {
      setState(() => _error = AppStrings.get(p.langCode, 'enter_current_password'));
      _speak(_error!);
      return;
    }
    if (newPass.isEmpty) {
      setState(() => _error = AppStrings.get(p.langCode, 'enter_new_password'));
      _speak(_error!);
      return;
    }
    if (newPass.length < 6) {
      setState(() => _error = AppStrings.get(p.langCode, 'password_too_short'));
      _speak(_error!);
      return;
    }
    if (newPass != confirm) {
      setState(() => _error = AppStrings.get(p.langCode, 'passwords_do_not_match'));
      _speak(_error!);
      return;
    }

    setState(() => _isLoading = true);
    final success = await MedicalAPIService.changePassword(
      currentPassword: current,
      newPassword: newPass,
    );
    setState(() => _isLoading = false);

    if (success) {
      setState(() {
        _isSuccess = true;
        _error = null;
      });
      await _speak(AppStrings.get(p.langCode, 'password_changed_success'));
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      setState(() => _error = AppStrings.get(p.langCode, 'change_password_failed'));
      await _speak(_error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0A07),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: _txtW, size: 16),
            ),
          ),
          title: Text(
            AppStrings.get(p.langCode, 'change_password'),
            style: const TextStyle(color: _txtW, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            FadeTransition(
              opacity: _fade,
              child: GestureDetector(
                onTap: () {
                  if (_awaitingConfirm) _confirmCurrent();
                },
                onDoubleTap: () {
                  if (_awaitingConfirm) _redoCurrent();
                },
                onLongPress: () {
                  if (p.isVoiceMode && !p.voiceDisabled && !_awaitingConfirm && !_isRecording && !_isSuccess) {
                    _startRecording();
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        AppStrings.get(p.langCode, 'change_password_subtitle'),
                        style: const TextStyle(color: _txtGray, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: _currentCtrl,
                        label: AppStrings.get(p.langCode, 'current_password'),
                        hint: AppStrings.get(p.langCode, 'enter_current_password'),
                        obscure: !_showCurrent,
                        onToggle: () => setState(() => _showCurrent = !_showCurrent),
                        isActive: _isVoiceMode && _currentStep == 0 && _awaitingConfirm,
                        isRecording: _isVoiceMode && _currentStep == 0 && _isRecording,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _newCtrl,
                        label: AppStrings.get(p.langCode, 'new_password'),
                        hint: AppStrings.get(p.langCode, 'enter_new_password'),
                        obscure: !_showNew,
                        onToggle: () => setState(() => _showNew = !_showNew),
                        isActive: _isVoiceMode && _currentStep == 1 && _awaitingConfirm,
                        isRecording: _isVoiceMode && _currentStep == 1 && _isRecording,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _confirmCtrl,
                        label: AppStrings.get(p.langCode, 'confirm_password'),
                        hint: AppStrings.get(p.langCode, 'confirm_new_password'),
                        obscure: !_showConfirm,
                        onToggle: () => setState(() => _showConfirm = !_showConfirm),
                        isActive: _isVoiceMode && _currentStep == 2 && _awaitingConfirm,
                        isRecording: _isVoiceMode && _currentStep == 2 && _isRecording,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _errorC.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _errorC.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: _errorC, size: 20),
                              const SizedBox(width: 12),
                              Expanded(child: Text(_error!, style: TextStyle(color: _errorC, fontSize: 13))),
                            ],
                          ),
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
                              Expanded(child: Text(
                                AppStrings.get(p.langCode, 'password_changed_success'),
                                style: TextStyle(color: _successC, fontSize: 13),
                              )),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: (_isLoading || _isSuccess) ? null : _validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
                              : Text(
                            AppStrings.get(p.langCode, 'change_password'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isVoiceMode && _isRecording)
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
                        style: const TextStyle(color: _txtW, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required bool isActive,
    required bool isRecording,
  }) {
    final borderColor = isRecording
        ? Colors.greenAccent
        : isActive
        ? _orange
        : _orange.withOpacity(0.25);
    final borderWidth = (isActive || isRecording) ? 2.0 : 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _txtGray, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1A110A).withOpacity(0.35),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(color: _txtW, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: _txtGray, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              if (isRecording)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _PulsingMic(),
                ),
              if (!isRecording)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: _txtGray,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
      builder: (_, __) => Icon(Icons.mic, color: Colors.greenAccent.withOpacity(_anim.value), size: 20),
    );
  }
}