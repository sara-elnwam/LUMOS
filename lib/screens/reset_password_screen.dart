import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart'
    show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector, AppStrings;

const _orange = Color(0xFFF27F0D);
const _txtW = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);
const _errorC = Color(0xFFEF4444);
const _successC = Color(0xFF22C55E);

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  final String? token;

  const ResetPasswordScreen({
    super.key,
    this.email,
    this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  final List<bool> _showPass = [false, false];
  final List<String?> _errors = List.filled(3, null);

  String? _token;
  bool _isLoading = false;
  bool _isSuccess = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final ShakeDetector _shake;

  int _currentIdx = 0;
  bool _awaitConfirm = false;
  bool _flowActive = false;
  bool _isRecording = false;
  Timer? _recordingTimer;
  String _currentPartialText = '';

  final List<Map<String, dynamic>> _fields = [
    {'label': 'email', 'hint': 'enter_email', 'isPassword': false},
    {'label': 'new_password', 'hint': 'create_password', 'isPassword': true},
    {'label': 'confirm_password', 'hint': 'confirm_password', 'isPassword': true},
  ];

  List<TextEditingController> get _ctrls => [_emailCtrl, _passwordCtrl, _confirmCtrl];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _shake = ShakeDetector(onShake: _onShake);
    _shake.start();

    if (widget.email != null) _emailCtrl.text = widget.email!;
    _token = widget.token;

    Future.delayed(const Duration(milliseconds: 600), _startFlow);
  }

  @override
  void dispose() {
    _shake.stop();
    _anim.dispose();
    _recordingTimer?.cancel();
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }


  Future<void> _startFlow() async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;
    _flowActive = true;
    await _speak(AppStrings.get(p.langCode, 'reset_password_instruction'));
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) await _promptField(0);
  }

  Future<void> _promptField(int idx) async {
    if (!mounted || !_flowActive) return;
    setState(() {
      _currentIdx = idx;
      _awaitConfirm = false;
    });
    final p = context.read<LocaleProvider>();
    final label = AppStrings.get(p.langCode, _fields[idx]['label'] as String);
    final msg = AppStrings.fill(p.langCode, 'prompt_enter_field', {'field': label});
    await _speak(msg);
  }

  Future<void> _onHoldStart(int idx) async {
    if (!mounted || _isRecording || _awaitConfirm) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;

    setState(() {
      _isRecording = true;
      _currentIdx = idx;
      _awaitConfirm = false;
      _currentPartialText = '';
    });

    await LumosHaptics.heartbeat();
    await _speak(AppStrings.fill(p.langCode, 'prompt_say_field',
        {'field': AppStrings.get(p.langCode, _fields[idx]['label'] as String)}));
    await Future.delayed(const Duration(milliseconds: 800));
    await LumosVoiceService.instance.startListening(
      lang: p.langCode,
      onPartial: _onPartialResult,
      onFinal: _onFinalResult,
    );
    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(seconds: 20), () {
      if (mounted && _isRecording) {
        debugPrint('[Recording] Auto-stopped after 20 seconds max');
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

    final p = context.read<LocaleProvider>();
    setState(() => _isRecording = false);
    final finalText = text.trim().isNotEmpty ? text.trim() : _currentPartialText.trim();

    if (finalText.isNotEmpty) {
      setState(() {
        _ctrls[_currentIdx].text = finalText;
        _errors[_currentIdx] = null;
        _awaitConfirm = true;
      });
      final isPassword = _fields[_currentIdx]['isPassword'] as bool;
      final readBack = isPassword
          ? AppStrings.fill(p.langCode, 'prompt_password_chars', {'n': finalText.length.toString()})
          : finalText;
      _speak(AppStrings.fill(p.langCode, 'prompt_confirm_entry', {'value': readBack}));
    } else {
      _speak(AppStrings.get(p.langCode, 'prompt_heard_nothing'));
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && _flowActive && !_awaitConfirm) {
          _promptField(_currentIdx);
        }
      });
    }
  }

  Future<void> _confirmCurrent() async {
    if (!_awaitConfirm || !_flowActive || !mounted) return;
    await LumosHaptics.tick();
    setState(() => _awaitConfirm = false);
    if (_currentIdx < _fields.length - 1) {
      await _promptField(_currentIdx + 1);
    } else {
      _validateAndReset();
    }
  }

  Future<void> _redoCurrent() async {
    if (!_awaitConfirm || !_flowActive || !mounted) return;
    await LumosHaptics.heartbeat();
    setState(() {
      _ctrls[_currentIdx].text = '';
      _awaitConfirm = false;
      _currentPartialText = '';
    });
    await _promptField(_currentIdx);
  }

  Future<void> _onShake() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled || _isRecording || _awaitConfirm) return;
    await _onHoldStart(_currentIdx);
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    if (!p.voiceDisabled) {
      await LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
    }
  }


  bool _validateAndReset() {
    final p = context.read<LocaleProvider>();
    bool valid = true;
    final newErrors = List<String?>.filled(3, null);

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    // Email validation
    if (email.isEmpty) {
      newErrors[0] = AppStrings.get(p.langCode, 'enter_email');
      valid = false;
    } else if (!email.contains('@') || !email.contains('.')) {
      newErrors[0] = AppStrings.get(p.langCode, 'invalid_email_format');
      valid = false;
    }

    // Password validation
    if (password.isEmpty) {
      newErrors[1] = AppStrings.get(p.langCode, 'enter_password');
      valid = false;
    } else if (password.length < 6) {
      newErrors[1] = AppStrings.get(p.langCode, 'password_too_short');
      valid = false;
    }

    // Confirm password validation
    if (confirm.isEmpty) {
      newErrors[2] = AppStrings.get(p.langCode, 'confirm_password');
      valid = false;
    } else if (password != confirm) {
      newErrors[2] = AppStrings.get(p.langCode, 'passwords_do_not_match');
      valid = false;
    }

    setState(() {
      for (int i = 0; i < 3; i++) _errors[i] = newErrors[i];
    });

    if (!valid) {
      final firstError = newErrors.firstWhere((e) => e != null, orElse: () => null);
      if (firstError != null) _speak(firstError);
      return false;
    }

    _callResetApi();
    return true;
  }

  Future<void> _callResetApi() async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final newPassword = _passwordCtrl.text;
    final token = _token ?? '';

    if (token.isEmpty) {
      setState(() {
        _isLoading = false;
        _errors[0] = AppStrings.get(p.langCode, 'invalid_reset_token');
      });
      await _speak(_errors[0]!);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://lumos-api.runasp.net/api/Account/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
        await _speak(AppStrings.get(p.langCode, 'password_reset_success'));

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/sign-in');
          }
        });
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
          _errors[0] = errorMsg;
        });
        await _speak(errorMsg);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errors[0] = AppStrings.get(p.langCode, 'network_error');
      });
      await _speak(_errors[0]!);
    }
  }


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
                _onHoldStart(_currentIdx);
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
                              AppStrings.get(p.langCode, 'reset_password_title'),
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
                              AppStrings.get(p.langCode, 'reset_password_subtitle'),
                              style: TextStyle(
                                color: _txtGray,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      ? (_) {
                                    setState(() => _currentIdx = 0);
                                    _onHoldStart(0);
                                  }
                                      : null,
                                  onLongPressEnd: (_) {},
                                  child: _GlassField(
                                    controller: _emailCtrl,
                                    hint: AppStrings.get(p.langCode, 'enter_email'),
                                    isRecording: _isRecording && _currentIdx == 0,
                                    isPassword: false,
                                    hasError: _errors[0] != null,
                                  ),
                                ),
                                if (_errors[0] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _errors[0]!,
                                    style: const TextStyle(color: _errorC, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.get(p.langCode, 'new_password'),
                                  style: const TextStyle(
                                    color: _txtGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onLongPressStart: p.isVoiceMode && !p.voiceDisabled && !_awaitConfirm && !_isSuccess
                                      ? (_) {
                                    setState(() => _currentIdx = 1);
                                    _onHoldStart(1);
                                  }
                                      : null,
                                  onLongPressEnd: (_) {},
                                  child: _GlassField(
                                    controller: _passwordCtrl,
                                    hint: AppStrings.get(p.langCode, 'create_password'),
                                    isRecording: _isRecording && _currentIdx == 1,
                                    isPassword: !_showPass[0],
                                    hasError: _errors[1] != null,
                                    suffix: GestureDetector(
                                      onTap: () => setState(() => _showPass[0] = !_showPass[0]),
                                      child: Icon(
                                        _showPass[0]
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: _txtGray,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_errors[1] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _errors[1]!,
                                    style: const TextStyle(color: _errorC, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.get(p.langCode, 'confirm_password'),
                                  style: const TextStyle(
                                    color: _txtGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onLongPressStart: p.isVoiceMode && !p.voiceDisabled && !_awaitConfirm && !_isSuccess
                                      ? (_) {
                                    setState(() => _currentIdx = 2);
                                    _onHoldStart(2);
                                  }
                                      : null,
                                  onLongPressEnd: (_) {},
                                  child: _GlassField(
                                    controller: _confirmCtrl,
                                    hint: AppStrings.get(p.langCode, 'confirm_password'),
                                    isRecording: _isRecording && _currentIdx == 2,
                                    isPassword: !_showPass[1],
                                    hasError: _errors[2] != null,
                                    suffix: GestureDetector(
                                      onTap: () => setState(() => _showPass[1] = !_showPass[1]),
                                      child: Icon(
                                        _showPass[1]
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: _txtGray,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_errors[2] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _errors[2]!,
                                    style: const TextStyle(color: _errorC, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: (_isLoading || _isSuccess) ? null : _validateAndReset,
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
                                AppStrings.get(p.langCode, 'reset_password'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
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
                                      AppStrings.get(p.langCode, 'password_reset_success'),
                                      style: TextStyle(color: _successC, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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


class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isRecording, isPassword, hasError;
  final Widget? suffix;

  const _GlassField({
    required this.controller,
    required this.hint,
    this.isRecording = false,
    this.isPassword = false,
    this.hasError = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isRecording
        ? Colors.greenAccent
        : hasError
        ? _errorC
        : _orange.withOpacity(0.25);
    final borderWidth = isRecording ? 2.0 : 0.8;
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
              obscureText: isPassword,
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
          if (suffix != null && !isRecording)
            Padding(padding: const EdgeInsets.only(right: 12), child: suffix),
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