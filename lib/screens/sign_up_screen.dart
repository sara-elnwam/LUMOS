// lib/screens/sign_up_screen.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart'
    show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector, AppStrings;
import 'medical_profile_screen.dart';

const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);
const _errorC  = Color(0xFFEF4444);

class _FieldDef {
  final String labelKey, hintKey;
  final bool   isPassword;
  final TextInputType keyboard;
  const _FieldDef({required this.labelKey, required this.hintKey,
    this.isPassword = false, this.keyboard = TextInputType.text});
}

const _fieldDefs = [
  _FieldDef(labelKey: 'full_name',       hintKey: 'enter_name',       keyboard: TextInputType.name),
  _FieldDef(labelKey: 'email',           hintKey: 'enter_email',      keyboard: TextInputType.emailAddress),
  _FieldDef(labelKey: 'password',        hintKey: 'create_password',  isPassword: true),
  _FieldDef(labelKey: 'repeat_password', hintKey: 'confirm_password', isPassword: true),
];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _ctrls = List.generate(4, (_) => TextEditingController());
  final List<bool>    _showPass = [false, false, false, false];
  final List<String?> _errors   = List.filled(4, null);

  late final AnimationController _anim;
  late final Animation<double>   _fade;
  late final ShakeDetector        _shake;

  int  _currentIdx   = 0;
  bool _awaitConfirm = false;
  bool _flowActive   = false;
  bool _isRecording  = false;
  bool _isLoading    = false;
  Timer? _recordingTimer;
  String _currentPartialText = '';

  @override
  void initState() {
    super.initState();
    _anim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _shake = ShakeDetector(onShake: _onShake);
    _shake.start();
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
    if (!p.isVoiceMode) return;
    _flowActive = true;
    await _speak(AppStrings.get(p.langCode, 'create_acc_title'));
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
    final label = AppStrings.get(p.langCode, _fieldDefs[idx].labelKey);
    final msg = AppStrings.fill(p.langCode, 'prompt_enter_field', {'field': label});
    await _speak(msg);
  }

  Future<void> _onHoldStart(int idx) async {
    if (!mounted || _isRecording || _awaitConfirm) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode) return;

    setState(() {
      _isRecording = true;
      _currentIdx = idx;
      _awaitConfirm = false;
      _currentPartialText = '';
    });

    await LumosHaptics.heartbeat();
    await _speak(AppStrings.fill(p.langCode, 'prompt_say_field', {'field': AppStrings.get(p.langCode, _fieldDefs[idx].labelKey)}));
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
    setState(() => _isRecording = false);
    final finalText = text.trim().isNotEmpty ? text.trim() : _currentPartialText.trim();
    if (finalText.isNotEmpty) {
      setState(() {
        _ctrls[_currentIdx].text = finalText;
      });
    }
    _handleSTTResult(_currentIdx, finalText);
  }

  Future<void> _onHoldEnd(int idx) async {
  }
  void _handleSTTResult(int idx, String text) {
    final p = context.read<LocaleProvider>();
    final f = _fieldDefs[idx];
    if (text.isNotEmpty) {
      final clean = text.trim();
      setState(() {
        _ctrls[idx].text = clean;
        _errors[idx] = null;
        _awaitConfirm = true;
      });
      final readBack = f.isPassword
          ? AppStrings.fill(p.langCode, 'prompt_password_chars', {'n': clean.length.toString()})
          : clean;
      _speak(AppStrings.fill(p.langCode, 'prompt_confirm_entry', {'value': readBack}));
    } else {
      _speak(AppStrings.get(p.langCode, 'prompt_heard_nothing'));
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && _flowActive && !_awaitConfirm) {
          _promptField(idx);
        }
      });
    }
  }

  Future<void> _confirmCurrent() async {
    if (!_awaitConfirm || !_flowActive || !mounted) return;
    await LumosHaptics.tick();
    setState(() => _awaitConfirm = false);
    if (_currentIdx < _fieldDefs.length - 1) {
      final nextIdx = _currentIdx + 1;
      await _promptField(nextIdx);
      FocusScope.of(context).nextFocus();
    } else {
      _validateAndProceed();
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
    if (!p.isVoiceMode || _isRecording || _awaitConfirm) return;
    await _onHoldStart(_currentIdx);
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    await LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
  }

  bool _validateAndProceed() {
    final p    = context.read<LocaleProvider>();
    bool valid = true;
    final newErrors = List<String?>.filled(4, null);

    const req = {'en':'Please fill in all fields before continuing.','ar':'يرجى ملء جميع الحقول قبل المتابعة.','es':'Por favor, completa todos los campos.','fr':'Veuillez remplir tous les champs.','de':'Bitte alle Felder ausfüllen.','ja':'すべての項目を入力してください。'};
    const mis = {'en':'Passwords do not match. Please try again.','ar':'كلمتا المرور غير متطابقتين. حاول مرة أخرى.','es':'Las contraseñas no coinciden.','fr':'Les mots de passe ne correspondent pas.','de':'Passwörter stimmen nicht überein.','ja':'パスワードが一致しません。'};

    for (int i = 0; i < _ctrls.length; i++) {
      if (_ctrls[i].text.trim().isEmpty) { newErrors[i] = req[p.langCode] ?? req['en']!; valid = false; }
    }
    if (valid && _ctrls[2].text != _ctrls[3].text) {
      newErrors[3] = mis[p.langCode] ?? mis['en']!; valid = false;
    }
    setState(() { for (int i = 0; i < 4; i++) _errors[i] = newErrors[i]; });
    if (!valid) {
      final firstError = newErrors.firstWhere((e) => e != null, orElse: () => null);
      if (firstError != null) _speak(firstError);
      return false;
    }
    _callCreateAccountApi();
    return true;
  }

  Future<void> _callCreateAccountApi() async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    setState(() => _isLoading = true);
    const secureStorage = FlutterSecureStorage();
    try {
      final response = await http.post(
        Uri.parse('http://lumos-api.runasp.net/api/Account/CreateNewAccount'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': _ctrls[0].text.trim(),
          'email':    _ctrls[1].text.trim(),
          'password': _ctrls[2].text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data  = jsonDecode(response.body) as Map<String, dynamic>;
        final name  = (data['fullName'] as String?) ?? _ctrls[0].text.trim();
        final token = (data['token']    as String?) ?? '';
        await secureStorage.write(key: 'token', value: token);
        setState(() => _isLoading = false);
        _goToMedical(context, name);
      } else {
        String mainErrorMsg = AppStrings.get(p.langCode, 'api_error');
        List<String?> newErrors = List.filled(_errors.length, null);
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['errors'] != null) {
            final apiErrors = errorData['errors'] as Map<String, dynamic>;if (apiErrors.containsKey('FullName')) {
              newErrors[0] = apiErrors['FullName'] is List ? apiErrors['FullName'].first : apiErrors['FullName'].toString();
            }
            if (apiErrors.containsKey('Email') || apiErrors.containsKey('email')) {
              newErrors[1] = apiErrors['Email'] ?? apiErrors['email'];
            }
            if (apiErrors.containsKey('Password')) {
              newErrors[2] = apiErrors['Password'] is List ? apiErrors['Password'].first : apiErrors['Password'].toString();
            }
            mainErrorMsg = newErrors.firstWhere((e) => e != null) ?? mainErrorMsg;
          }
        } catch (e) {
        }

        setState(() {
          _isLoading = false;
          for (int i = 0; i < _errors.length; i++) {
            _errors[i] = newErrors[i];
          }
        });

        await _speak(mainErrorMsg);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errors[0] = AppStrings.get(p.langCode, 'api_error');
      });
      await _speak(AppStrings.get(p.langCode, 'api_error'));
    }
  }

  void _goToMedical(BuildContext ctx, String name) async {
    final p = ctx.read<LocaleProvider>();
    if (name.isNotEmpty) await p.completeRegistration(name);
    LumosHaptics.success();
    if (ctx.mounted) {
      Navigator.of(ctx).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (c, anim, __) => const MedicalProfileScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
          final fade  = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: anim, curve: const Interval(0.0, 0.5)));
          return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
        },
      ));
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
            onTap: () { if (_awaitConfirm) _confirmCurrent(); },
            onDoubleTap: () { if (_awaitConfirm) _redoCurrent(); },
            onLongPressStart: (_) {
              if (p.isVoiceMode && !_awaitConfirm && !_isRecording) _onHoldStart(_currentIdx);
            },
            onLongPressEnd: (_) {
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.asset('assets/images/lumos_background.png', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(decoration: const BoxDecoration(
                      gradient: RadialGradient(center: Alignment.bottomCenter, radius: 1.4,
                          colors: [Color(0xFF3D1A00), Color(0xFF0D0A07)]),
                    )),
                  ),
                ),
                Positioned.fill(child: Container(decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.20),
                      Colors.black.withOpacity(0.45)
                    ],
                  ),
                ))),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 40),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF393535).withOpacity(0.25), width: 0.8),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFFF2F2F2).withOpacity(0.03), blurRadius: 22, spreadRadius: -4),
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 22, spreadRadius: -4, offset: const Offset(10, 10)),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Center(child: Text(AppStrings.get(p.langCode, 'create_acc_title'),
                            style: const TextStyle(color: _orange, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.75))),
                        const SizedBox(height: 24),
                        ...List.generate(_fieldDefs.length, (i) {
                          final f = _fieldDefs[i];
                          final label = AppStrings.get(p.langCode, f.labelKey);
                          final hint = AppStrings.get(p.langCode, f.hintKey);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(label, style: const TextStyle(
                                  color: _txtGray, fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onLongPressStart: p.isVoiceMode && !_awaitConfirm
                                    ? (_) { setState(() => _currentIdx = i); _onHoldStart(i); } : null,
                                onLongPressEnd: (_) => {},
                                child: _GlassField(
                                  controller: _ctrls[i], hint: hint,
                                  isRecording: _isRecording && _currentIdx == i,
                                  isPassword: f.isPassword && !_showPass[i],
                                  keyboard: f.keyboard, hasError: _errors[i] != null,
                                  suffix: f.isPassword ? GestureDetector(
                                      onTap: () => setState(() => _showPass[i] = !_showPass[i]),
                                      child: Icon(_showPass[i] ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          color: _txtGray, size: 20)) : null,
                                ),
                              ),
                              if (_errors[i] != null) ...[
                                const SizedBox(height: 4),
                                Text(_errors[i]!, style: const TextStyle(color: _errorC, fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ]),
                          );
                        }),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity, height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _validateAndProceed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _orange, foregroundColor: Colors.white,
                                disabledBackgroundColor: _orange.withOpacity(0.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                            child: _isLoading
                                ? const SizedBox(width: 22, height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : Text(AppStrings.get(p.langCode, 'sign_up'),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                if (_isLoading) Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
                if (p.isVoiceMode && _isRecording)
                  Positioned(bottom: 48, left: 20, right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.88), borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: _orange.withOpacity(0.4))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.mic, color: _orange, size: 18),
                        const SizedBox(width: 10),
                        Text(AppStrings.get(p.langCode, 'tts_listening'),
                            style: const TextStyle(color: _txtW, fontSize: 13, fontWeight: FontWeight.w500)),
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

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isRecording, isPassword, hasError;
  final Widget? suffix;
  final TextInputType keyboard;
  const _GlassField({required this.controller, required this.hint,
    this.isRecording = false, this.isPassword = false, this.hasError = false,
    this.suffix, this.keyboard = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? _errorC : _orange.withOpacity(0.25);
    final borderWidth = 0.8;
    final bgColor = const Color(0xFF1A110A).withOpacity(0.35);
    return Container(
      height: 48,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: borderWidth)),
      child: Row(children: [
        Expanded(child: TextField(
            controller: controller, obscureText: isPassword, keyboardType: keyboard,
            style: const TextStyle(color: _txtW, fontSize: 15),
            decoration: InputDecoration(hintText: hint,
                hintStyle: const TextStyle(color: _txtGray, fontSize: 15), border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13)))),
        if (suffix != null) Padding(padding: const EdgeInsets.only(right: 12), child: suffix),
      ]),
    );
  }
}