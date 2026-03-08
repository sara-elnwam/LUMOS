import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/biometrics_screen.dart';
import 'screens/medical_profile_screen.dart';
// ============================================================
//  TRANSLATIONS
// ============================================================
class AppStrings {
  static const Map<String, Map<String, String>> _all = {
    'en': {
      'choose_language': 'Choose Language',
      'subtitle': 'Select your preferred language to customize your experience.',
      'search': 'Search languages...',
      'next': 'Next',
      'default_lang': 'Default system language',
      'welcome': 'Welcome to Lumos',
      'choose_voice': 'Choose A Voice\nFor Your Assistant',
      'male_voice': 'Male Voice',
      'female_voice': 'Female Voice',
      'create_account': 'Create A New Account',
      'already_account': 'Already Have An Account',
      'sign_up': 'Sign up',
      'sign_in': 'Sign in',
      'full_name': 'Full name',
      'enter_name': 'Enter your full name',
      'email': 'Email address',
      'enter_email': 'Enter your email',
      'password': 'Password',
      'create_password': 'Create a password',
      'repeat_password': 'Repeat password',
      'confirm_password': 'Confirm your password',
      'create_acc_title': 'Create account',
      'medical_profile': 'Medical Profile',
      'sex': 'Sex',
      'male': 'Male',
      'female': 'Female',
      'blood_type': 'Blood Type',
      'allergies': 'Allergies',
      'medications': 'Medications',
      'diseases': 'Diseases',
      'continue': 'Continue',
    },
    'ar': {
      'choose_language': 'اختر اللغة',
      'subtitle': 'اختر لغتك المفضلة لتخصيص تجربتك.',
      'search': 'ابحث عن لغة...',
      'next': 'التالي',
      'default_lang': 'لغة النظام الافتراضية',
      'welcome': 'مرحباً بك في لوموس',
      'choose_voice': 'اختر صوتاً\nلمساعدك',
      'male_voice': 'صوت ذكر',
      'female_voice': 'صوت أنثى',
      'create_account': 'إنشاء حساب جديد',
      'already_account': 'لدي حساب بالفعل',
      'sign_up': 'إنشاء حساب',
      'sign_in': 'تسجيل الدخول',
      'full_name': 'الاسم الكامل',
      'enter_name': 'أدخل اسمك الكامل',
      'email': 'البريد الإلكتروني',
      'enter_email': 'أدخل بريدك الإلكتروني',
      'password': 'كلمة المرور',
      'create_password': 'أنشئ كلمة مرور',
      'repeat_password': 'تأكيد كلمة المرور',
      'confirm_password': 'أكد كلمة المرور',
      'create_acc_title': 'إنشاء حساب',
      'medical_profile': 'الملف الطبي',
      'sex': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'blood_type': 'فصيلة الدم',
      'allergies': 'الحساسية',
      'medications': 'الأدوية',
      'diseases': 'الأمراض',
      'continue': 'متابعة',
    },
    'es': {
      'choose_language': 'Elegir idioma',
      'subtitle': 'Selecciona tu idioma preferido.',
      'search': 'Buscar idiomas...',
      'next': 'Siguiente',
      'default_lang': 'Idioma del sistema',
      'welcome': 'Bienvenido a Lumos',
      'choose_voice': 'Elige Una Voz\nPara Tu Asistente',
      'male_voice': 'Voz Masculina',
      'female_voice': 'Voz Femenina',
      'create_account': 'Crear Una Nueva Cuenta',
      'already_account': 'Ya Tengo Una Cuenta',
      'sign_up': 'Registrarse',
      'sign_in': 'Iniciar sesión',
      'full_name': 'Nombre completo',
      'enter_name': 'Ingresa tu nombre',
      'email': 'Correo electrónico',
      'enter_email': 'Ingresa tu correo',
      'password': 'Contraseña',
      'create_password': 'Crea una contraseña',
      'repeat_password': 'Repetir contraseña',
      'confirm_password': 'Confirma tu contraseña',
      'create_acc_title': 'Crear cuenta',
      'medical_profile': 'Perfil Médico',
      'sex': 'Sexo',
      'male': 'Masculino',
      'female': 'Femenino',
      'blood_type': 'Tipo de sangre',
      'allergies': 'Alergias',
      'medications': 'Medicamentos',
      'diseases': 'Enfermedades',
      'continue': 'Continuar',
    },
    'fr': {
      'choose_language': 'Choisir la langue',
      'subtitle': 'Sélectionnez votre langue préférée.',
      'search': 'Rechercher...',
      'next': 'Suivant',
      'default_lang': 'Langue système',
      'welcome': 'Bienvenue sur Lumos',
      'choose_voice': 'Choisissez Une Voix\nPour Votre Assistant',
      'male_voice': 'Voix Masculine',
      'female_voice': 'Voix Féminine',
      'create_account': 'Créer Un Nouveau Compte',
      'already_account': 'J\'ai Déjà Un Compte',
      'sign_up': 'S\'inscrire',
      'sign_in': 'Se connecter',
      'full_name': 'Nom complet',
      'enter_name': 'Entrez votre nom',
      'email': 'Adresse e-mail',
      'enter_email': 'Entrez votre e-mail',
      'password': 'Mot de passe',
      'create_password': 'Créez un mot de passe',
      'repeat_password': 'Répéter le mot de passe',
      'confirm_password': 'Confirmez votre mot de passe',
      'create_acc_title': 'Créer un compte',
      'medical_profile': 'Profil Médical',
      'sex': 'Sexe',
      'male': 'Masculin',
      'female': 'Féminin',
      'blood_type': 'Groupe sanguin',
      'allergies': 'Allergies',
      'medications': 'Médicaments',
      'diseases': 'Maladies',
      'continue': 'Continuer',
    },
    'de': {
      'choose_language': 'Sprache wählen',
      'subtitle': 'Wähle deine bevorzugte Sprache.',
      'search': 'Sprachen suchen...',
      'next': 'Weiter',
      'default_lang': 'Standardsprache',
      'welcome': 'Willkommen bei Lumos',
      'choose_voice': 'Wähle Eine Stimme\nFür Deinen Assistenten',
      'male_voice': 'Männliche Stimme',
      'female_voice': 'Weibliche Stimme',
      'create_account': 'Neues Konto Erstellen',
      'already_account': 'Ich Habe Bereits Ein Konto',
      'sign_up': 'Registrieren',
      'sign_in': 'Anmelden',
      'full_name': 'Vollständiger Name',
      'enter_name': 'Gib deinen Namen ein',
      'email': 'E-Mail-Adresse',
      'enter_email': 'Gib deine E-Mail ein',
      'password': 'Passwort',
      'create_password': 'Erstelle ein Passwort',
      'repeat_password': 'Passwort wiederholen',
      'confirm_password': 'Bestätige dein Passwort',
      'create_acc_title': 'Konto erstellen',
      'medical_profile': 'Medizinisches Profil',
      'sex': 'Geschlecht',
      'male': 'Männlich',
      'female': 'Weiblich',
      'blood_type': 'Blutgruppe',
      'allergies': 'Allergien',
      'medications': 'Medikamente',
      'diseases': 'Krankheiten',
      'continue': 'Weiter',
    },
    'ja': {
      'choose_language': '言語を選択',
      'subtitle': 'お好みの言語を選択してください。',
      'search': '言語を検索...',
      'next': '次へ',
      'default_lang': 'デフォルト言語',
      'welcome': 'Lumosへようこそ',
      'choose_voice': 'アシスタントの\n声を選んでください',
      'male_voice': '男性の声',
      'female_voice': '女性の声',
      'create_account': '新しいアカウントを作成',
      'already_account': 'すでにアカウントをお持ちの方',
      'sign_up': '登録する',
      'sign_in': 'ログイン',
      'full_name': '氏名',
      'enter_name': '氏名を入力',
      'email': 'メールアドレス',
      'enter_email': 'メールを入力',
      'password': 'パスワード',
      'create_password': 'パスワードを作成',
      'repeat_password': 'パスワードを繰り返す',
      'confirm_password': 'パスワードを確認',
      'create_acc_title': 'アカウント作成',
      'medical_profile': '医療プロフィール',
      'sex': '性別',
      'male': '男性',
      'female': '女性',
      'blood_type': '血液型',
      'allergies': 'アレルギー',
      'medications': '薬',
      'diseases': '病気',
      'continue': '続ける',
    },
  };

  static String get(String langCode, String key) =>
      _all[langCode]?[key] ?? _all['en']![key] ?? key;
}

// ============================================================
//  LOCALE PROVIDER
// ============================================================
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

// ============================================================
//  MAIN
// ============================================================
void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => LocaleProvider(), child: const LumosApp()),
  );
}

class LumosApp extends StatelessWidget {
  const LumosApp({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return MaterialApp(
      title: 'Lumos',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(textDirection: p.dir, child: child!),
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      initialRoute: '/',
      routes: {
        '/':                (_) => const SplashScreen(),
        '/choose-language': (_) => const ChooseLanguageScreen(),
        '/choose-voice':    (_) => const ChooseVoiceScreen(),
        '/get-started':     (_) => const GetStartedScreen(),
        '/sign-up':         (_) => const SignUpScreen(),
        '/sign-in':         (_) => const SignInScreen(),
        '/medical-profile': (_) => const MedicalProfileScreen(),
        '/biometrics':      (_) => const BiometricsScreen(),
        '/home':            (_) => const HomeScreen(),
      },
    );
  }
}

// ============================================================
//  SHARED COLORS & WIDGETS
// ============================================================
const _bg      = Color(0xFF1A1008);
const _card    = Color(0xFF2A1A08);
const _selCard = Color(0xFF3A2210);
const _orange  = Color(0xFFF27F0D);
const _border  = Color(0xFF5C360F);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _fieldBg = Color(0xFF140F0A);

class _BottomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BottomButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _orange, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _orange, foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
      ),
    );
  }
}

// ============================================================
//  SPLASH SCREEN
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _fc, _sc, _ec;
  late final Animation<double> _f, _s, _e;
  @override
  void initState() {
    super.initState();
    _fc = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _sc = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _ec = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _f = CurvedAnimation(parent: _fc, curve: Curves.easeIn);
    _s = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _sc, curve: Curves.easeInOut));
    _e = CurvedAnimation(parent: _ec, curve: Curves.easeIn);
    _run();
  }
  Future<void> _run() async {
    _fc.forward(); _sc.forward();
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) await _ec.forward();
    if (mounted) Navigator.of(context).pushReplacementNamed('/choose-language');
  }
  @override void dispose() { _fc.dispose(); _sc.dispose(); _ec.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(child: FadeTransition(opacity: _f,
            child: AnimatedBuilder(animation: _s,
                builder: (_, child) => Transform.scale(scale: _s.value, child: child),
                child: Image.asset('assets/images/splash.png', width: 800, height: 800, fit: BoxFit.contain)))),
        FadeTransition(opacity: _e, child: Container(color: Colors.white)),
      ]),
    );
  }
}

// ============================================================
//  CHOOSE LANGUAGE SCREEN
// ============================================================
class _Lang { final String name, code; final bool isDefault; const _Lang(this.name, this.code, {this.isDefault = false}); }
const _langs = [
  _Lang('English (US)',      'en', isDefault: true),
  _Lang('Spanish (Español)', 'es'),
  _Lang('French (Français)', 'fr'),
  _Lang('German (Deutsch)',  'de'),
  _Lang('Japanese (日本語)', 'ja'),
  _Lang('Arabic (العربية)',  'ar'),
];

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});
  @override State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}
class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> with SingleTickerProviderStateMixin {
  late String _sel; String _search = ''; final _ctrl = TextEditingController();
  late final AnimationController _anim; late final Animation<double> _fade;
  @override void initState() { super.initState(); _sel = context.read<LocaleProvider>().langCode; _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500)); _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn); _anim.forward(); }
  @override void dispose() { _anim.dispose(); _ctrl.dispose(); super.dispose(); }
  List<_Lang> get _filtered => _search.isEmpty ? _langs : _langs.where((l) => l.name.toLowerCase().contains(_search.toLowerCase())).toList();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(textDirection: p.dir, child: Scaffold(backgroundColor: _bg,
        body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 32, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.tr('choose_language'), style: const TextStyle(color: _txtW, fontSize: 32, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(p.tr('subtitle'), style: const TextStyle(color: _txtGray, fontSize: 15, height: 1.5)),
            const SizedBox(height: 24),
            Container(height: 50,
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border.withOpacity(0.5))),
                child: Row(children: [
                  const SizedBox(width: 14), const Icon(Icons.search, color: _txtGray, size: 20), const SizedBox(width: 10),
                  Expanded(child: TextField(controller: _ctrl, onChanged: (v) => setState(() => _search = v),
                      style: const TextStyle(color: _txtW, fontSize: 15),
                      decoration: InputDecoration(hintText: p.tr('search'), hintStyle: const TextStyle(color: _txtGray, fontSize: 15), border: InputBorder.none, isDense: true))),
                ])),
            const SizedBox(height: 20),
            ..._filtered.map((lang) => Padding(padding: const EdgeInsets.only(bottom: 10),
                child: _LangTile(lang: lang, isSelected: _sel == lang.code, defaultLabel: p.tr('default_lang'), onTap: () => setState(() => _sel = lang.code)))),
            const SizedBox(height: 16),
          ]))),
          _BottomButton(label: p.tr('next'), onTap: () { context.read<LocaleProvider>().setLang(_sel); Navigator.of(context).pushReplacementNamed('/choose-voice'); }),
        ])))));
  }
}

class _LangTile extends StatelessWidget {
  final _Lang lang; final bool isSelected; final String defaultLabel; final VoidCallback onTap;
  const _LangTile({required this.lang, required this.isSelected, required this.defaultLabel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: isSelected ? _selCard : _card, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? _orange : _border, width: isSelected ? 1.5 : 1)),
        child: Row(children: [
          AnimatedContainer(duration: const Duration(milliseconds: 200), width: 24, height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? _orange : Colors.transparent, border: Border.all(color: _orange, width: isSelected ? 0 : 2)),
              child: isSelected ? const Icon(Icons.circle, color: Colors.white, size: 10) : null),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(lang.name, style: TextStyle(color: _txtW, fontSize: 16, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
            if (lang.isDefault) ...[const SizedBox(height: 2), Text(defaultLabel, style: const TextStyle(color: _txtGray, fontSize: 13))],
          ])),
          if (isSelected) Container(width: 26, height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _orange, width: 1.5)),
              child: const Icon(Icons.check, color: _orange, size: 16)),
        ])));
  }
}

// ============================================================
//  CHOOSE VOICE SCREEN
// ============================================================
class ChooseVoiceScreen extends StatefulWidget {
  const ChooseVoiceScreen({super.key});
  @override State<ChooseVoiceScreen> createState() => _ChooseVoiceScreenState();
}
class _ChooseVoiceScreenState extends State<ChooseVoiceScreen> with SingleTickerProviderStateMixin {
  String _sel = 'male';
  late final AnimationController _anim; late final Animation<double> _fade;
  @override void initState() { super.initState(); _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500)); _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn); _anim.forward(); }
  @override void dispose() { _anim.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(textDirection: p.dir, child: Scaffold(backgroundColor: _bg,
        body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
          Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.tr('choose_voice'), style: const TextStyle(color: _orange, fontSize: 36, fontWeight: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 48),
            Row(children: [
              Expanded(child: _VoiceCard(label: p.tr('male_voice'), imagePath: 'assets/images/male_3d_icon.png', isSelected: _sel == 'male', onTap: () => setState(() => _sel = 'male'))),
              const SizedBox(width: 16),
              Expanded(child: _VoiceCard(label: p.tr('female_voice'), imagePath: 'assets/images/female_3d_icon.png', isSelected: _sel == 'female', onTap: () => setState(() => _sel = 'female'))),
            ]),
          ]))),
          _BottomButton(label: p.tr('next'), onTap: () => Navigator.of(context).pushReplacementNamed('/get-started')),
        ])))));
  }
}

class _VoiceCard extends StatelessWidget {
  final String label, imagePath; final bool isSelected; final VoidCallback onTap;
  const _VoiceCard({required this.label, required this.imagePath, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isSelected ? _orange : _card, borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected ? [BoxShadow(color: _orange.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6))] : []),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(alignment: Alignment.topRight, child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              width: 28, height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.black : Colors.transparent, border: Border.all(color: isSelected ? Colors.black : _orange, width: 1.5)),
              child: Icon(Icons.check, size: 16, color: isSelected ? _orange : _orange.withOpacity(0.5)))),
          Center(child: SizedBox(height: 120, child: Image.asset(imagePath, fit: BoxFit.contain))),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : _txtW, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(Icons.graphic_eq, color: isSelected ? Colors.white70 : _txtGray, size: 24),
            Container(width: 32, height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.black26 : _border),
                child: Icon(Icons.play_arrow, size: 18, color: isSelected ? Colors.white : _orange)),
          ]),
        ])));
  }
}

// ============================================================
//  GET STARTED SCREEN
// ============================================================
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  @override State<GetStartedScreen> createState() => _GetStartedScreenState();
}
class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim; late final Animation<double> _fade;
  @override void initState() { super.initState(); _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500)); _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn); _anim.forward(); }
  @override void dispose() { _anim.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(textDirection: p.dir, child: Scaffold(backgroundColor: _bg,
        body: FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
          const Spacer(),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
            // Create A New Account
            SizedBox(width: double.infinity, height: 94,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(p.tr('create_account'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                )),
            const SizedBox(height: 20),
            // Already Have An Account
            SizedBox(width: double.infinity, height: 94,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-in'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _orange, width: 1.5),
                    backgroundColor: _fieldBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(p.tr('already_account'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                )),
          ])),
          const Spacer(),
        ])))));
  }
}

// ============================================================
//  HOME SCREEN
// ============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(textDirection: p.dir, child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Lumos')),
        body: Center(child: Text(p.tr('welcome'), style: const TextStyle(fontSize: 22)))));
  }
}