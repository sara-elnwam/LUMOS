// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/voice_service.dart';
import 'l10n/app_strings.dart';
import 'screens/accessibility_mode_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/biometrics_screen.dart';
import 'screens/biometrics_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/medical_profile_screen.dart';
import 'screens/qr_profile_screen.dart';

// ════════════════════════════════════════════════════════════
//  LOCALE PROVIDER (backward compat)
// ════════════════════════════════════════════════════════════
class LocaleProvider extends ChangeNotifier {
  String _langCode = 'en';
  String get langCode => _langCode;
  bool get isRTL => _langCode == 'ar';
  TextDirection get dir => isRTL ? TextDirection.rtl : TextDirection.ltr;
  String tr(String key) => AppStrings.get(_langCode, key);
  void setLang(String code) {
    if (_langCode == code) return;
    _langCode = code;
    notifyListeners();
  }
}

// ════════════════════════════════════════════════════════════
//  MAIN
// ════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VoiceService().init();
  final appProvider = AppProvider();
  await appProvider.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: appProvider),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ], child: const LumosApp()));
}

// ════════════════════════════════════════════════════════════
//  APP
// ════════════════════════════════════════════════════════════
class LumosApp extends StatelessWidget {
  const LumosApp({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return MaterialApp(
      title: 'Lumos',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(textDirection: p.dir, child: child!),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      initialRoute: '/',
      routes: {
        '/':                   (_) => const SplashScreen(),
        '/accessibility-mode': (_) => const AccessibilityModeScreen(),
        '/choose-language':    (_) => const ChooseLanguageScreen(),
        '/choose-voice':       (_) => const ChooseVoiceScreen(),
        '/get-started':        (_) => const GetStartedScreen(),
        '/sign-up':            (_) => const SignUpScreen(),
        '/sign-in':            (_) => const SignInScreen(),
        '/medical-profile':    (_) => const MedicalProfileScreen(),
        '/qr-profile':         (_) => const QrProfileScreen(),
        '/biometrics':         (_) => const BiometricsScreen(),
        '/biometrics-login':   (_) => const BiometricsLoginScreen(),
        '/home':               (_) => const HomeScreen(),
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
//  COLORS
// ════════════════════════════════════════════════════════════
const _bg      = Color(0xFF1A1008);
const _card    = Color(0xFF2A1A08);
const _orange  = Color(0xFFF27F0D);
const _border  = Color(0xFF5C360F);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _fieldBg = Color(0xFF140F0A);

// ════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ════════════════════════════════════════════════════════════
class _BottomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BottomButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: _bg, border: Border(top: BorderSide(color: _orange, width: 1))),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: SizedBox(width: double.infinity, height: 56,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1)),
          )),
    );
  }
}

/// GlowPainter — exported for QrProfileScreen
class GlowPainter extends CustomPainter {
  const GlowPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, size.width * 0.7,
        Paint()..shader = RadialGradient(colors: [const Color(0xFFF27F0D).withOpacity(0.10), Colors.transparent])
            .createShader(Rect.fromCircle(center: Offset.zero, radius: size.width * 0.7)));
    canvas.drawCircle(Offset(size.width, size.height), size.width * 0.6,
        Paint()..shader = RadialGradient(colors: [const Color(0xFFF27F0D).withOpacity(0.07), Colors.transparent])
            .createShader(Rect.fromCircle(center: Offset(size.width, size.height), radius: size.width * 0.6)));
  }
  @override
  bool shouldRepaint(_) => false;
}

/// VoiceHintBanner — renders NOTHING (TTS speaks instead of showing text)
class VoiceHintBanner extends StatelessWidget {
  final String hint;
  const VoiceHintBanner({super.key, required this.hint});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ════════════════════════════════════════════════════════════
//  SPLASH
//  — يشتغل لمدة ~2 ثانية
//  — يعمل vibration خفيف
//  — TTS يقول "Lumos" بلغة الموبايل الحالية
//  — لو المستخدم سبق سجّل دخول يروح /home مباشرة
//  — لو اختار mode بس مش سجّل دخول يروح /choose-language
//  — لأول مرة يروح /accessibility-mode
// ════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _fc, _sc, _ec;
  late final Animation<double> _f, _s, _e;

  @override
  void initState() {
    super.initState();
    // Animation durations compressed to ~2 second total splash
    _fc = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _sc = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _ec = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _f = CurvedAnimation(parent: _fc, curve: Curves.easeIn);
    _s = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _sc, curve: Curves.easeInOut));
    _e = CurvedAnimation(parent: _ec, curve: Curves.easeIn);
    _run();
  }

  /// Returns the word "Lumos" written/transliterated for natural TTS in each language
  String _lumosWord(String lang) {
    switch (lang) {
      case 'ar': return 'لوموس';
      case 'ja': return 'ルーモス';
      default:   return 'Lumos';
    }
  }

  Future<void> _run() async {
    _fc.forward();
    _sc.forward();

    // ── Detect device language ────────────────────────────
    final sysCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    const supported = ['en', 'ar', 'es', 'fr', 'de', 'ja'];
    final deviceLang = supported.contains(sysCode) ? sysCode : 'en';

    // ── Light haptic feedback ─────────────────────────────
    HapticFeedback.mediumImpact();

    // ── Small delay then speak "Lumos" ────────────────────
    await Future.delayed(const Duration(milliseconds: 350));
    await VoiceService().speak(_lumosWord(deviceLang), lang: deviceLang);

    // ── Small pause after TTS then navigate ───────────────
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final p = context.read<AppProvider>();

    // ── Routing logic (persistent state) ─────────────────
    // Already logged in → go straight to home
    if (p.isLoggedIn) {
      await _ec.forward();
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      return;
    }
    // Chose mode but not logged in → skip accessibility/lang/voice setup
    if (p.interactionMode != null) {
      await _ec.forward();
      if (mounted) Navigator.of(context).pushReplacementNamed('/choose-language');
      return;
    }
    // First time → full onboarding
    await _ec.forward();
    if (mounted) Navigator.of(context).pushReplacementNamed('/accessibility-mode');
  }

  @override
  void dispose() { _fc.dispose(); _sc.dispose(); _ec.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(child: FadeTransition(opacity: _f,
            child: AnimatedBuilder(animation: _s, builder: (_, child) => Transform.scale(scale: _s.value, child: child),
                child: Image.asset('assets/images/splash.png', width: 800, height: 800, fit: BoxFit.contain)))),
        FadeTransition(opacity: _e, child: Container(color: Colors.white)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LANGUAGE DATA
// ════════════════════════════════════════════════════════════
class _Lang {
  final String code;
  final Map<String, String> names;
  final bool isDefault;
  const _Lang(this.code, this.names, {this.isDefault = false});
  String nameIn(String uiLang) => names[uiLang] ?? names['en'] ?? code;
}

const _langs = [
  _Lang('en', {'en': 'English (US)', 'ar': 'الإنجليزية', 'es': 'Inglés',    'fr': 'Anglais',    'de': 'Englisch',  'ja': '英語'},        isDefault: true),
  _Lang('ar', {'en': 'Arabic',       'ar': 'العربية',    'es': 'Árabe',      'fr': 'Arabe',      'de': 'Arabisch',  'ja': 'アラビア語'}),
  _Lang('es', {'en': 'Spanish',      'ar': 'الإسبانية',  'es': 'Español',    'fr': 'Espagnol',   'de': 'Spanisch',  'ja': 'スペイン語'}),
  _Lang('fr', {'en': 'French',       'ar': 'الفرنسية',   'es': 'Francés',    'fr': 'Français',   'de': 'Französisch','ja': 'フランス語'}),
  _Lang('de', {'en': 'German',       'ar': 'الألمانية',  'es': 'Alemán',     'fr': 'Allemand',   'de': 'Deutsch',   'ja': 'ドイツ語'}),
  _Lang('ja', {'en': 'Japanese',     'ar': 'اليابانية',  'es': 'Japonés',    'fr': 'Japonais',   'de': 'Japanisch', 'ja': '日本語'}),
];

// ════════════════════════════════════════════════════════════
//  CHOOSE LANGUAGE SCREEN
// ════════════════════════════════════════════════════════════
class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});
  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen>
    with SingleTickerProviderStateMixin {
  late String _sel;
  String _search = '';
  final _ctrl = TextEditingController();
  late final AnimationController _anim;
  late final Animation<double> _fade;
  int _tapCount = 0;
  Timer? _tapTimer;
  bool _browsingMode = false;
  int _browseIndex = 0;
  late String _uiLang;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();

    final sysCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    _uiLang = _langs.any((l) => l.code == sysCode) ? sysCode : 'en';

    final p = context.read<AppProvider>();
    _sel = (p.langCode == 'en') ? _uiLang : p.langCode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (p.isVoiceMode) _speakIntro(p);
    });
  }

  Future<void> _speakIntro(AppProvider p) async {
    await VoiceService().speak(AppStrings.get(_uiLang, 'tts_screen_lang'), lang: _uiLang, gender: p.voiceGender);
    final devName = _langs.firstWhere((l) => l.code == _uiLang, orElse: () => _langs.first).nameIn(_uiLang);
    await VoiceService().speak(
      AppStrings.fill(_uiLang, 'tts_lang_intro', {'lang': devName}),
      lang: _uiLang, gender: p.voiceGender,
    );
  }

  @override
  void dispose() { _anim.dispose(); _ctrl.dispose(); _tapTimer?.cancel(); VoiceService().stop(); super.dispose(); }

  List<_Lang> get _filtered => _search.isEmpty
      ? _langs
      : _langs.where((l) => l.nameIn(_uiLang).toLowerCase().contains(_search.toLowerCase())).toList();

  void _onScreenTap() {
    final p = context.read<AppProvider>();
    if (!p.isVoiceMode) return;
    _tapCount++;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 450), () {
      final taps = _tapCount; _tapCount = 0;
      if (_browsingMode) { if (taps >= 1) _selectBrowsed(p); }
      else { if (taps == 1) _confirmCurrent(p); else if (taps >= 2) _startBrowse(p); }
    });
  }

  Future<void> _confirmCurrent(AppProvider p) async {
    final lang = _langs.firstWhere((l) => l.code == _sel, orElse: () => _langs.first);
    await VoiceService().speak(AppStrings.fill(_sel, 'tts_lang_selected', {'lang': lang.nameIn(_sel)}), lang: _sel, gender: p.voiceGender);
    _proceed(p);
  }

  Future<void> _startBrowse(AppProvider p) async {
    setState(() { _browsingMode = true; _browseIndex = 0; });
    await VoiceService().speak(AppStrings.get(_uiLang, 'tts_lang_browse'), lang: _uiLang, gender: p.voiceGender);
    _readBrowseCurrent();
  }

  Future<void> _readBrowseCurrent() async {
    final lang = _langs[_browseIndex];
    await VoiceService().speak(lang.nameIn(lang.code), lang: lang.code);
  }

  Future<void> _selectBrowsed(AppProvider p) async {
    final chosen = _langs[_browseIndex];
    setState(() { _sel = chosen.code; _browsingMode = false; });
    await VoiceService().speak(AppStrings.fill(chosen.code, 'tts_lang_selected', {'lang': chosen.nameIn(chosen.code)}), lang: chosen.code, gender: p.voiceGender);
    _proceed(p);
  }

  void _proceed(AppProvider p) {
    p.setLang(_sel);
    context.read<LocaleProvider>().setLang(_sel);
    if (mounted) Navigator.of(context).pushReplacementNamed('/choose-voice');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final String Function(String) s = (String k) => AppStrings.get(_uiLang, k);
    final isRTL = AppStrings.isRTL(_uiLang);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: _onScreenTap, behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: _bg,
          body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s('choose_language'), style: const TextStyle(color: _txtW, fontSize: 32, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(s('lang_subtitle'), style: const TextStyle(color: _txtGray, fontSize: 15, height: 1.5)),
                const SizedBox(height: 24),
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border.withOpacity(0.5))),
                  child: Row(children: [
                    const SizedBox(width: 14), const Icon(Icons.search, color: _txtGray, size: 20), const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _ctrl, onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(color: _txtW, fontSize: 15),
                        decoration: InputDecoration(hintText: s('search_langs'), hintStyle: const TextStyle(color: _txtGray, fontSize: 15), border: InputBorder.none, isDense: true))),
                  ]),
                ),
                const SizedBox(height: 20),
                ..._filtered.map((lang) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _LangTile(
                    displayName: lang.nameIn(_uiLang),
                    isSelected: _sel == lang.code,
                    isBrowseFocused: _browsingMode && _langs[_browseIndex].code == lang.code,
                    isDefault: lang.isDefault,
                    defaultLabel: s('default_lang'),
                    onTap: () { if (!p.isVoiceMode) setState(() => _sel = lang.code); },
                  ),
                )),
                const SizedBox(height: 16),
              ]),
            )),
            _BottomButton(label: s('next'), onTap: () => _proceed(p)),
          ]))),
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String displayName, defaultLabel;
  final bool isSelected, isBrowseFocused, isDefault;
  final VoidCallback onTap;
  const _LangTile({required this.displayName, required this.defaultLabel, required this.isSelected, required this.isBrowseFocused, required this.isDefault, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final hi = isSelected || isBrowseFocused;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isBrowseFocused ? _orange.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: hi ? _orange : _orange.withOpacity(0.25), width: hi ? 1.5 : 1),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200), width: 24, height: 24,
            decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? _orange : Colors.transparent, border: Border.all(color: _orange, width: isSelected ? 0 : 2)),
            child: isSelected ? const Icon(Icons.circle, color: Colors.white, size: 10) : null,
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(displayName, style: TextStyle(color: _txtW, fontSize: 16, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
            if (isDefault) ...[const SizedBox(height: 2), Text(defaultLabel, style: const TextStyle(color: _txtGray, fontSize: 13))],
          ])),
          if (isSelected) Container(width: 26, height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _orange, width: 1.5)),
              child: const Icon(Icons.check, color: _orange, size: 16)),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  CHOOSE VOICE SCREEN
//
//  Voice mode:
//    — TTS يشرح: اضغط يمين لصوت الولد، اضغط شمال لصوت البنت
//    — كل ضغطة يعزف sample بالصوت المختار
//    — بعد ما يعجبه الصوت يضغط في النص للتأكيد
//  Manual mode:
//    — يضغط على الكارت مباشرة + زر Next
// ════════════════════════════════════════════════════════════
class ChooseVoiceScreen extends StatefulWidget {
  const ChooseVoiceScreen({super.key});
  @override
  State<ChooseVoiceScreen> createState() => _ChooseVoiceScreenState();
}

class _ChooseVoiceScreenState extends State<ChooseVoiceScreen> with SingleTickerProviderStateMixin {
  String _sel = 'female';
  late final AnimationController _anim;
  late final Animation<double> _fade;
  int _tapCount = 0;
  Timer? _tapTimer;
  bool _previewed = false; // has user previewed at least one voice?

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    final p = context.read<AppProvider>();
    _sel = p.voiceGender;
    WidgetsBinding.instance.addPostFrameCallback((_) { if (p.isVoiceMode) _speakIntro(p); });
  }

  Future<void> _speakIntro(AppProvider p) async {
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_screen_voice'), lang: p.langCode, gender: p.voiceGender);
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_voice_intro'), lang: p.langCode, gender: p.voiceGender);
  }

  @override
  void dispose() { _anim.dispose(); _tapTimer?.cancel(); VoiceService().stop(); super.dispose(); }

  // ── Handles tap position: right half = male, left half = female ──
  void _onTapUp(TapUpDetails details, AppProvider p) {
    if (!p.isVoiceMode) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final isRightSide = details.globalPosition.dx > screenWidth / 2;
    _previewVoice(isRightSide ? 'male' : 'female', p);
  }

  // ── Center tap = confirm ──────────────────────────────────
  void _onCenterTap(AppProvider p) {
    if (!p.isVoiceMode) return;
    if (!_previewed) {
      // User hasn't previewed yet — speak sample first
      _previewVoice(_sel, p);
      return;
    }
    _tapCount++;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 350), () {
      final taps = _tapCount; _tapCount = 0;
      if (taps >= 1) _confirm(p);
    });
  }

  Future<void> _previewVoice(String gender, AppProvider p) async {
    setState(() { _sel = gender; _previewed = true; });
    // Play "see beyond limits" as preview sample (as requested)
    final sample = AppStrings.get(p.langCode, gender == 'female' ? 'tts_voice_female_sample' : 'tts_voice_male_sample');
    await VoiceService().speak(sample, lang: p.langCode, gender: gender);
    // After sample, remind user how to confirm
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_voice_confirm_hint'), lang: p.langCode, gender: gender);
  }

  Future<void> _confirm(AppProvider p) async {
    await p.setVoiceGender(_sel);
    final confirmMsg = AppStrings.fill(p.langCode, 'tts_voice_chosen', {'gender': AppStrings.get(p.langCode, _sel == 'female' ? 'female_voice' : 'male_voice')});
    await VoiceService().speak(confirmMsg, lang: p.langCode, gender: _sel);
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_voice_confirmed'), lang: p.langCode, gender: _sel);
    if (mounted) Navigator.of(context).pushReplacementNamed('/get-started');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final String Function(String) s = (String k) => AppStrings.get(p.langCode, k);
    return Directionality(
      textDirection: p.dir,
      child: GestureDetector(
        // Full-screen tap up handler: left/right = preview, center = confirm
        onTapUp: (d) {
          if (!p.isVoiceMode) return;
          final sw = MediaQuery.of(context).size.width;
          final cx = d.globalPosition.dx;
          // Left 35% = female, Right 35% = male, Middle 30% = confirm
          if (cx < sw * 0.35) {
            _previewVoice('female', p);
          } else if (cx > sw * 0.65) {
            _previewVoice('male', p);
          } else {
            _onCenterTap(p);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(backgroundColor: _bg,
            body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
              Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s('choose_voice'), style: const TextStyle(color: _orange, fontSize: 36, fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 48),
                  Row(children: [
                    Expanded(child: _VoiceCard(
                        label: s('female_voice'),
                        imagePath: 'assets/images/female_3d_icon.png',
                        isSelected: _sel == 'female',
                        onTap: () {
                          setState(() => _sel = 'female');
                          _previewVoice('female', p);
                        })),
                    const SizedBox(width: 16),
                    Expanded(child: _VoiceCard(
                        label: s('male_voice'),
                        imagePath: 'assets/images/male_3d_icon.png',
                        isSelected: _sel == 'male',
                        onTap: () {
                          setState(() => _sel = 'male');
                          _previewVoice('male', p);
                        })),
                  ]),
                  // Voice mode instruction hint
                  if (p.isVoiceMode) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _orange.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _orange.withOpacity(0.25)),
                      ),
                      child: Text(
                        s('voice_hint_voice_screen'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: _txtGray, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ]),
              )),
              _BottomButton(label: s('next'), onTap: () { p.setVoiceGender(_sel); Navigator.of(context).pushReplacementNamed('/get-started'); }),
            ])))),
      ),
    );
  }
}

class _VoiceCard extends StatelessWidget {
  final String label, imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  const _VoiceCard({required this.label, required this.imagePath, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isSelected ? _orange : Colors.black.withOpacity(0.50),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isSelected ? _orange : const Color(0xFFFFB267).withOpacity(0.25), width: 1),
            boxShadow: isSelected ? [BoxShadow(color: _orange.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6))] : [],
          ),
          child: Padding(padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Align(alignment: Alignment.topRight,
                    child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 28, height: 28,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: isSelected ? Colors.black.withOpacity(0.3) : Colors.transparent,
                            border: Border.all(color: isSelected ? Colors.black.withOpacity(0.5) : _orange.withOpacity(0.4), width: 1.5)),
                        child: Icon(Icons.check, size: 16, color: isSelected ? Colors.white : _orange.withOpacity(0.4)))),
                const SizedBox(height: 4),
                Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                  SizedBox(width: double.infinity, height: 185, child: Image.asset(imagePath, fit: BoxFit.contain)),
                  Positioned(bottom: 20, left: 0, right: 0,
                      child: Text(label, textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 16.71, fontWeight: FontWeight.w700, height: 26 / 16.71))),
                ]),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Icon(Icons.graphic_eq, color: isSelected ? Colors.white70 : _orange.withOpacity(0.4), size: 24),
                  Container(width: 32, height: 32,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.black26 : _orange.withOpacity(0.15)),
                      child: Icon(Icons.play_arrow, size: 18, color: isSelected ? Colors.white : _orange)),
                ]),
              ])),
        ));
  }
}

// ════════════════════════════════════════════════════════════
//  GET STARTED SCREEN
//
//  Voice mode:
//    — زر فوق (Create Account) = اضغط فوق
//    — زر تحت (Sign In) = اضغط تحت
//  الزرارين كبار وبينهم مسافة واضحة
// ════════════════════════════════════════════════════════════
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      if (p.isVoiceMode) _speakIntro(p);
    });
  }

  Future<void> _speakIntro(AppProvider p) async {
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_screen_getstarted'), lang: p.langCode, gender: p.voiceGender);
    await VoiceService().speak(AppStrings.get(p.langCode, 'tts_getstarted_intro'), lang: p.langCode, gender: p.voiceGender);
  }

  @override
  void dispose() { _anim.dispose(); _tapTimer?.cancel(); VoiceService().stop(); super.dispose(); }

  // ── Tap position: top half = new account, bottom half = sign in ──
  void _onTapUp(TapUpDetails details) {
    final p = context.read<AppProvider>();
    if (!p.isVoiceMode) return;
    final screenHeight = MediaQuery.of(context).size.height;
    if (details.globalPosition.dy < screenHeight / 2) {
      Navigator.of(context).pushReplacementNamed('/sign-up');
    } else {
      Navigator.of(context).pushReplacementNamed('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final String Function(String) s = (String k) => AppStrings.get(p.langCode, k);
    return Directionality(
      textDirection: p.dir,
      child: GestureDetector(
        onTapUp: _onTapUp,
        behavior: HitTestBehavior.translucent,
        child: Scaffold(backgroundColor: _bg,
            body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
              // مسافة كبيرة فوق عشان الزر الأول يكون بوضوح في النص العلوي
              const Spacer(flex: 3),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
                // زر فوق — Create Account
                SizedBox(width: double.infinity, height: 94,
                    child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-up'),
                        style: ElevatedButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                        child: Text(s('create_account'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)))),
                // مسافة كبيرة بين الزرارين
                const SizedBox(height: 40),
                // زر تحت — Already Have Account
                SizedBox(width: double.infinity, height: 94,
                    child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-in'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white,
                            side: const BorderSide(color: _orange, width: 1.5), backgroundColor: _fieldBg,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Text(s('already_account'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)))),
              ])),
              // مسافة كبيرة تحت
              const Spacer(flex: 3),
            ])))),
      ),
    );
  }
}