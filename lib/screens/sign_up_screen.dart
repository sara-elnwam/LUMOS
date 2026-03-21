// lib/screens/sign_up_screen.dart
//
// Manual mode → normal form, password typed in text field
// Voice mode  → STT collects name + email
//               PIN pad (6 digits spoken one by one) for password
//               Secure: PIN never displayed, never repeated aloud fully
// ════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/voice_service.dart';
import '../l10n/app_strings.dart';
import '../main.dart' show LocaleProvider, VoiceHintBanner;
import 'medical_profile_screen.dart';

const _bg      = Color(0xFF1A1008);
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF64748B);

// ════════════════════════════════════════════════════════════
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum _VStep { name, email, pin, pinConfirm, done }

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {

  // Manual controllers
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _showPass = false, _showConf = false;

  // Voice state
  _VStep _vStep = _VStep.name;
  String _vName = '', _vEmail = '';
  String _vPin = '', _vPinConfirm = '';
  bool _isListening = false;
  String _listenStatus = '';
  bool _awaitingConfirm = false;
  String _pendingValue = '';

  int _tapCount = 0;
  Timer? _tapTimer;

  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      if (p.isVoiceMode) _startVoice(p);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confCtrl.dispose();
    _tapTimer?.cancel();
    VoiceService().stop();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  //  VOICE FLOW
  // ════════════════════════════════════════════════════════
  Future<void> _startVoice(AppProvider p) async {
    final lang = p.langCode;
    // 1. Screen intro
    await VoiceService().speak(AppStrings.get(lang, 'tts_screen_signup'), lang: lang, gender: p.voiceGender);
    // 2. General intro
    await VoiceService().speak(AppStrings.get(lang, 'tts_signup_intro'), lang: lang, gender: p.voiceGender);
    // 3. Start with name
    _askName(p);
  }

  Future<void> _askName(AppProvider p) async {
    setState(() { _vStep = _VStep.name; _awaitingConfirm = false; });
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_signup_name'), lang: p.langCode, gender: p.voiceGender);
    _listenText(p);
  }

  Future<void> _askEmail(AppProvider p) async {
    setState(() { _vStep = _VStep.email; _awaitingConfirm = false; });
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_signup_email'), lang: p.langCode, gender: p.voiceGender);
    _listenText(p);
  }

  Future<void> _listenText(AppProvider p) async {
    setState(() { _isListening = true; _listenStatus = AppStrings.get(p.langCode, 'tts_listening'); });
    final result = await VoiceService().listen(
        lang: p.langCode, onPartial: (s) => setState(() => _listenStatus = s));
    setState(() { _isListening = false; _listenStatus = ''; });

    if (result.isEmpty) { _listenText(p); return; }

    _pendingValue = result;
    _awaitingConfirm = true;

    final confirmKey = _vStep == _VStep.name
        ? 'tts_signup_name_confirm'
        : 'tts_signup_email_confirm';
    await VoiceService().speak(
      AppStrings.fill(p.langCode, confirmKey, {'value': result}),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  // ── Secure PIN collection ──────────────────────────────
  Future<void> _askPin(AppProvider p, {bool confirm = false}) async {
    setState(() {
      _vStep = confirm ? _VStep.pinConfirm : _VStep.pin;
      _awaitingConfirm = false;
      if (confirm) _vPinConfirm = ''; else _vPin = '';
    });
    final key = confirm ? 'tts_pin_confirm_intro' : 'tts_pin_intro';
    await VoiceService().speak(AppStrings.get(p.langCode, key), lang: p.langCode, gender: p.voiceGender);
    _collectPinDigits(p, confirm: confirm);
  }

  Future<void> _collectPinDigits(AppProvider p, {bool confirm = false}) async {
    final digits = <String>[];
    while (digits.length < 6) {
      setState(() { _isListening = true; _listenStatus = '${digits.length + 1}/6'; });
      final result = await VoiceService().listen(lang: p.langCode, timeout: const Duration(seconds: 5));
      setState(() { _isListening = false; });

      // Extract first digit from speech
      final digit = _extractDigit(result);
      if (digit == null) continue; // didn't hear a valid digit, retry

      digits.add(digit);
      // Confirm each digit briefly
      await VoiceService().speak(
        AppStrings.fill(p.langCode, 'tts_pin_heard', {'digit': digit}),
        lang: p.langCode, gender: p.voiceGender,
      );
    }

    final pin = digits.join();
    if (confirm) {
      _vPinConfirm = pin;
    } else {
      _vPin = pin;
    }

    // Read back as "PIN received" — NOT the actual digits
    await VoiceService().speak(
      AppStrings.get(p.langCode, confirm ? 'tts_pin_confirm_intro' : 'tts_pin_full')
          .replaceAll('{pin}', '••••••'),
      lang: p.langCode, gender: p.voiceGender,
    );

    setState(() { _awaitingConfirm = true; });
  }

  String? _extractDigit(String speech) {
    final lower = speech.toLowerCase().trim();
    const map = {
      'zero': '0', 'صفر': '0', 'cero': '0', 'zéro': '0', 'null': '0', 'ゼロ': '0', 'れい': '0',
      'one': '1', 'واحد': '1', 'uno': '1', 'un': '1', 'eins': '1', 'いち': '1',
      'two': '2', 'اثنان': '2', 'dos': '2', 'deux': '2', 'zwei': '2', 'に': '2',
      'three': '3', 'ثلاثة': '3', 'tres': '3', 'trois': '3', 'drei': '3', 'さん': '3',
      'four': '4', 'أربعة': '4', 'cuatro': '4', 'quatre': '4', 'vier': '4', 'し': '4',
      'five': '5', 'خمسة': '5', 'cinco': '5', 'cinq': '5', 'fünf': '5', 'ご': '5',
      'six': '6', 'ستة': '6', 'seis': '6', 'sechs': '6', 'ろく': '6',
      'seven': '7', 'سبعة': '7', 'siete': '7', 'sept': '7', 'sieben': '7', 'なな': '7',
      'eight': '8', 'ثمانية': '8', 'ocho': '8', 'huit': '8', 'acht': '8', 'はち': '8',
      'nine': '9', 'تسعة': '9', 'nueve': '9', 'neuf': '9', 'neun': '9', 'きゅう': '9',
    };

    // Direct digit character
    for (final ch in lower.split('')) {
      if (RegExp(r'[0-9]').hasMatch(ch)) return ch;
    }
    // Word match
    for (final entry in map.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return null;
  }

  // ── Tap handler ─────────────────────────────────────────
  void _onTap() {
    final p = context.read<AppProvider>();
    if (!p.isVoiceMode || !_awaitingConfirm) return;
    _tapCount++;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 450), () {
      final taps = _tapCount; _tapCount = 0;
      if (taps == 1) _confirmField(p);
      else if (taps >= 2) _repeatField(p);
    });
  }

  void _confirmField(AppProvider p) {
    setState(() { _awaitingConfirm = false; });
    switch (_vStep) {
      case _VStep.name:
        _vName = _pendingValue;
        _nameCtrl.text = _vName;
        _askEmail(p);
        break;
      case _VStep.email:
        _vEmail = _pendingValue;
        _emailCtrl.text = _vEmail;
        _askPin(p);
        break;
      case _VStep.pin:
        _askPin(p, confirm: true);
        break;
      case _VStep.pinConfirm:
        if (_vPin == _vPinConfirm) {
          _passCtrl.text = _vPin;
          _confCtrl.text = _vPinConfirm;
          _submitVoice(p);
        } else {
          VoiceService().speak(AppStrings.get(p.langCode, 'tts_pin_mismatch'),
              lang: p.langCode, gender: p.voiceGender)
              .then((_) => _askPin(p));
        }
        break;
      default: break;
    }
  }

  void _repeatField(AppProvider p) {
    setState(() { _awaitingConfirm = false; });
    switch (_vStep) {
      case _VStep.name:            _askName(p); break;
      case _VStep.email:           _askEmail(p); break;
      case _VStep.pin:             _askPin(p); break;
      case _VStep.pinConfirm:      _askPin(p, confirm: true); break;
      default: break;
    }
  }

  Future<void> _submitVoice(AppProvider p) async {
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_signup_done'),
        lang: p.langCode, gender: p.voiceGender);
    _saveAndGo(p);
  }

  // ── Manual submit ────────────────────────────────────────
  void _onManualSubmit() => _saveAndGo(context.read<AppProvider>());

  Future<void> _saveAndGo(AppProvider p) async {
    await p.saveUser(UserData(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    ));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, anim, __) => const MedicalProfileScreen(),
      transitionsBuilder: (_, anim, __, child) {
        final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: anim, curve: const Interval(0, 0.5)));
        return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
      },
    ));
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final lang = p.langCode;
    final String Function(String) s = (String k) => AppStrings.get(lang, k);
    final isRTL = AppStrings.isRTL(lang);
    if (p.isVoiceMode) return _buildVoiceUI(p, s, isRTL);
    return _buildManualUI(p, s, isRTL);
  }

  // ════════════════════════════════════════════════════════
  //  VOICE UI — minimal screen, TTS does all the work
  // ════════════════════════════════════════════════════════
  Widget _buildVoiceUI(AppProvider p, String Function(String) s, bool isRTL) {
    final stepTitles = {
      _VStep.name:        s('full_name'),
      _VStep.email:       s('email'),
      _VStep.pin:         s('password'),
      _VStep.pinConfirm:  s('repeat_password'),
      _VStep.done:        s('done'),
    };
    final stepIndex = _vStep.index.clamp(0, 3);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: _onTap, behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: FadeTransition(opacity: _fade,
              child: Stack(fit: StackFit.expand, children: [
                Positioned.fill(child: Image.asset('assets/images/lumos_background.png',
                    fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.black))),
                Positioned.fill(child: Container(color: Colors.black.withOpacity(0.62))),
                SafeArea(child: Column(children: [
                  const Spacer(),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Column(children: [
                    // Step dots
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) =>
                        AnimatedContainer(duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == stepIndex ? 28 : 8, height: 8,
                            decoration: BoxDecoration(
                                color: i == stepIndex ? _orange : _orange.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(4))))),
                    const SizedBox(height: 28),
                    // Current field label
                    Text(stepTitles[_vStep] ?? '', style: const TextStyle(color: _orange, fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 24),
                    // Status card
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _orange.withOpacity(0.40), width: 1.5)),
                      child: _buildVoiceCardContent(s),
                    ),
                  ])),
                  const Spacer(),
                ])),
              ])),
        ),
      ),
    );
  }

  Widget _buildVoiceCardContent(String Function(String) s) {
    // PIN steps — show only bullet dots, never actual digits
    if (_vStep == _VStep.pin || _vStep == _VStep.pinConfirm) {
      final filled = _vStep == _VStep.pin ? _vPin.length : _vPinConfirm.length;
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) =>
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 18, height: 18,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < filled ? _orange : Colors.transparent,
                    border: Border.all(color: i < filled ? _orange : _orange.withOpacity(0.35), width: 2))))),
        const SizedBox(height: 16),
        if (_isListening) ...[
          const SizedBox(height: 8),
          Text(_listenStatus, style: TextStyle(color: _txtW.withOpacity(0.70), fontSize: 14)),
        ] else if (_awaitingConfirm) ...[
          Text('tap once to confirm  ·  twice to redo',
              style: TextStyle(color: _orange.withOpacity(0.70), fontSize: 12), textAlign: TextAlign.center),
        ],
      ]);
    }

    // Name / email steps
    if (_isListening) {
      return Column(children: [
        const CircularProgressIndicator(color: _orange, strokeWidth: 2),
        const SizedBox(height: 14),
        Text(_listenStatus.isEmpty ? s('tts_listening') : _listenStatus,
            style: const TextStyle(color: _txtW, fontSize: 17), textAlign: TextAlign.center),
      ]);
    }
    if (_awaitingConfirm) {
      return Column(children: [
        Text(_pendingValue, style: const TextStyle(color: _txtW, fontSize: 22, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        const SizedBox(height: 14),
        Text('tap once to confirm  ·  twice to redo',
            style: TextStyle(color: _orange.withOpacity(0.70), fontSize: 12), textAlign: TextAlign.center),
      ]);
    }
    return Icon(Icons.mic, color: _orange.withOpacity(0.40), size: 40);
  }

  // ════════════════════════════════════════════════════════
  //  MANUAL UI
  // ════════════════════════════════════════════════════════
  Widget _buildManualUI(AppProvider p, String Function(String) s, bool isRTL) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(opacity: _fade,
            child: Stack(fit: StackFit.expand, children: [
              Positioned.fill(child: Image.asset('assets/images/lumos_background.png',
                  fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.black))),
              Positioned.fill(child: Container(color: Colors.black.withOpacity(0.45))),
              Center(child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _orange.withOpacity(0.15))),
                  child: Padding(padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Center(child: Text(s('create_acc_title'),
                            style: const TextStyle(color: _orange, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5))),
                        const SizedBox(height: 24),

                        _Label(s('full_name')), const SizedBox(height: 6),
                        _Field(controller: _nameCtrl, hint: s('enter_name'), isRTL: isRTL),
                        const SizedBox(height: 16),

                        _Label(s('email')), const SizedBox(height: 6),
                        _Field(controller: _emailCtrl, hint: s('enter_email'), keyboardType: TextInputType.emailAddress, isRTL: isRTL),
                        const SizedBox(height: 16),

                        _Label(s('password')), const SizedBox(height: 6),
                        _Field(controller: _passCtrl, hint: s('create_password'), obscure: !_showPass, isRTL: isRTL,
                            suffix: GestureDetector(onTap: () => setState(() => _showPass = !_showPass),
                                child: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _txtGray, size: 20))),
                        const SizedBox(height: 16),

                        _Label(s('repeat_password')), const SizedBox(height: 6),
                        _Field(controller: _confCtrl, hint: s('confirm_password'), obscure: !_showConf, isRTL: isRTL,
                            suffix: GestureDetector(onTap: () => setState(() => _showConf = !_showConf),
                                child: Icon(_showConf ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _txtGray, size: 20))),
                        const SizedBox(height: 24),

                        SizedBox(width: double.infinity, height: 48,
                            child: ElevatedButton(
                                onPressed: _onManualSubmit,
                                style: ElevatedButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                                child: Text(s('sign_up'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
                      ])),
                ),
              )),
            ])),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: _txtW, fontSize: 14, fontWeight: FontWeight.w500));
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure, isRTL;
  final Widget? suffix;
  final TextInputType? keyboardType;
  const _Field({required this.controller, required this.hint, required this.isRTL, this.obscure = false, this.suffix, this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(color: const Color(0x36221910), borderRadius: BorderRadius.circular(8), border: Border.all(color: _orange, width: 1)),
      child: Directionality(textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: TextField(controller: controller, obscureText: obscure, keyboardType: keyboardType,
              style: const TextStyle(color: _txtW, fontSize: 15),
              decoration: InputDecoration(
                  hintText: hint, hintStyle: const TextStyle(color: _txtGray, fontSize: 15),
                  suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix) : null,
                  suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13)))),
    );
  }
}