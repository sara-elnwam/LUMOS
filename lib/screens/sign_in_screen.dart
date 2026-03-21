// lib/screens/sign_in_screen.dart
//
// Manual mode  → normal form + validate against stored user
// Voice mode   → STT: email → password → 1tap confirm / 2tap repeat
// ═════ ═══ ═══ =================================═══════  ═════ ════ ════ ═══ ══ ═══════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/voice_service.dart';
import '../l10n/app_strings.dart';
import '../main.dart' show LocaleProvider, VoiceHintBanner;

const _bg      = Colors.black;
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _fieldBg = Color(0x0DFFFFFF);

// ════════════════════════════════════════════════════════════
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

enum _VoiceStep { email, password, done }

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {

  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _showPass   = false;

  // Voice
  _VoiceStep _voiceStep = _VoiceStep.email;
  String _pendingEmail = '';
  String _pendingPass  = '';
  bool _awaitingConfirm = false;
  bool _isListening = false;
  String _listenStatus = '';

  int _tapCount = 0;
  Timer? _tapTimer;

  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      if (p.isVoiceMode) {
        VoiceService().speak(
          AppStrings.get(p.langCode, 'tts_screen_signin'),
          lang: p.langCode, gender: p.voiceGender,
        ).then((_) => VoiceService().speak(
          AppStrings.get(p.langCode, 'tts_signin_intro'),
          lang: p.langCode, gender: p.voiceGender,
        ).then((_) => _listenEmail(p)));
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _tapTimer?.cancel();
    VoiceService().stop();
    super.dispose();
  }

  // ── Voice flow ──────────────────────────────────────────
  Future<void> _listenEmail(AppProvider p) async {
    setState(() {
      _voiceStep = _VoiceStep.email;
      _awaitingConfirm = false;
      _isListening = true;
      _listenStatus = '';
    });
    final result = await VoiceService().listen(
      lang: p.langCode,
      onPartial: (partial) => setState(() => _listenStatus = partial),
    );
    setState(() { _isListening = false; _listenStatus = ''; });

    if (result.isEmpty) { _listenEmail(p); return; }
    _pendingEmail = result;
    _awaitingConfirm = true;
    await VoiceService().speak(
      AppStrings.fill(p.langCode, 'tts_signin_email_confirm', {'value': result}),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  Future<void> _listenPassword(AppProvider p) async {
    setState(() {
      _voiceStep = _VoiceStep.password;
      _awaitingConfirm = false;
      _isListening = true;
      _listenStatus = '';
    });
    await VoiceService().speak(
      AppStrings.get(p.langCode, 'tts_signin_password'),
      lang: p.langCode, gender: p.voiceGender,
    );
    final result = await VoiceService().listen(lang: p.langCode);
    setState(() { _isListening = false; _listenStatus = ''; });

    if (result.isEmpty) { _listenPassword(p); return; }
    _pendingPass = result;
    _awaitingConfirm = true;
    await VoiceService().speak(
      AppStrings.get(p.langCode, 'tts_signin_password_confirm'),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  // ── Tap handler ─────────────────────────────────────────
  void _onTap() {
    final p = context.read<AppProvider>();
    if (!p.isVoiceMode) return;
    _tapCount++;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 450), () {
      final taps = _tapCount;
      _tapCount = 0;
      if (!_awaitingConfirm) return;
      if (taps == 1) _confirmVoiceField(p);
      if (taps >= 2) _repeatVoiceField(p);
    });
  }

  void _confirmVoiceField(AppProvider p) {
    if (_voiceStep == _VoiceStep.email) {
      _emailCtrl.text = _pendingEmail;
      _listenPassword(p);
    } else if (_voiceStep == _VoiceStep.password) {
      _passCtrl.text = _pendingPass;
      _signInVoice(p);
    }
  }

  void _repeatVoiceField(AppProvider p) {
    if (_voiceStep == _VoiceStep.email) _listenEmail(p);
    else _listenPassword(p);
  }

  Future<void> _signInVoice(AppProvider p) async {
    final ok = p.validateSignIn(_emailCtrl.text, _passCtrl.text);
    if (ok) {
      await p.setLoggedIn(true);
      await VoiceService().speak(
        AppStrings.fill(p.langCode, 'tts_signin_success',
            {'name': p.user?.name ?? ''}),
        lang: p.langCode, gender: p.voiceGender,
      );
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } else {
      await VoiceService().speak(
        AppStrings.get(p.langCode, 'tts_signin_fail'),
        lang: p.langCode, gender: p.voiceGender,
      );
      _listenEmail(p);
    }
  }

  // ── Manual sign in ───────────────────────────────────────
  void _manualSignIn() async {
    final p = context.read<AppProvider>();
    final ok = p.validateSignIn(_emailCtrl.text, _passCtrl.text);
    if (ok) {
      await p.setLoggedIn(true);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/biometrics-login');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get(p.langCode, 'tts_signin_fail')),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final lang = p.langCode;
    final String Function(String) s = (String k) => AppStrings.get(lang, k);
    final isRTL = AppStrings.isRTL(lang);

    if (p.isVoiceMode) {
      return _buildVoiceUI(p, s, isRTL);
    }
    return _buildManualUI(s, isRTL);
  }

  // ── VOICE UI ─────────────────────────────────────────────
  Widget _buildVoiceUI(AppProvider p, String Function(String) s, bool isRTL) {
    final stepLabel = _voiceStep == _VoiceStep.email ? s('email') : s('password');
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: FadeTransition(
            opacity: _fade,
            child: Stack(fit: StackFit.expand, children: [
              Positioned.fill(
                child: Image.asset('assets/images/lumos_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black)),
              ),
              Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.65))),
              SafeArea(
                child: Column(children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(children: [
                      // Step dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _voiceStep.index ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _voiceStep.index
                                ? _orange
                                : _orange.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                      const SizedBox(height: 28),
                      Text(stepLabel,
                          style: const TextStyle(
                              color: _orange, fontSize: 28,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.70),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: _orange.withOpacity(0.40), width: 1.5),
                        ),
                        child: _isListening
                            ? Column(children: [
                          const CircularProgressIndicator(
                              color: _orange, strokeWidth: 2),
                          const SizedBox(height: 12),
                          Text(_listenStatus.isEmpty
                              ? s('tts_listening')
                              : _listenStatus,
                              style: const TextStyle(
                                  color: _txtW, fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ])
                            : _awaitingConfirm
                            ? Column(children: [
                          Text(
                            _voiceStep == _VoiceStep.password
                                ? '••••••••'
                                : (_voiceStep == _VoiceStep.email
                                ? _pendingEmail
                                : ''),
                            style: const TextStyle(
                                color: _txtW, fontSize: 22,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(s('hint_signin'),
                              style: TextStyle(
                                  color: _orange.withOpacity(0.80),
                                  fontSize: 13),
                              textAlign: TextAlign.center),
                        ])
                            : Icon(Icons.mic,
                            color: _orange.withOpacity(0.50), size: 40),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  VoiceHintBanner(hint: s('hint_signin')),
                  const SizedBox(height: 16),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ── MANUAL UI ────────────────────────────────────────────
  Widget _buildManualUI(String Function(String) s, bool isRTL) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(
          opacity: _fade,
          child: Stack(fit: StackFit.expand, children: [
            Positioned.fill(
              child: Image.asset('assets/images/lumos_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.black)),
            ),
            Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.45))),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.82),
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(s('welcome_back'),
                              style: const TextStyle(
                                  color: _orange, fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5)),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(s('signin_subtitle'),
                              style: const TextStyle(
                                  color: _txtGray, fontSize: 16)),
                        ),
                        const SizedBox(height: 32),

                        _FieldLabel(s('email')),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _emailCtrl,
                          hint: s('enter_email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _FieldLabel(s('password')),
                            GestureDetector(
                              onTap: () {},
                              child: Text(s('forgot_password'),
                                  style: const TextStyle(
                                      color: _orange, fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _passCtrl,
                          hint: s('create_password'),
                          obscure: !_showPass,
                          suffix: GestureDetector(
                            onTap: () => setState(
                                    () => _showPass = !_showPass),
                            child: Icon(
                              _showPass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _txtGray, size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity, height: 52,
                          child: ElevatedButton(
                            onPressed: _manualSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orange,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: Text(s('sign_in'),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Reusable field widgets ───────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: _txtW, fontSize: 15, fontWeight: FontWeight.w500));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  const _InputField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _orange, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: _txtW, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _txtGray, fontSize: 15),
          suffixIcon: suffix != null
              ? Padding(
              padding: const EdgeInsets.only(right: 14),
              child: suffix)
              : null,
          suffixIconConstraints:
          const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}