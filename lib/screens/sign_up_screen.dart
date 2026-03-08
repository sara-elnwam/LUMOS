// lib/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider, AppStrings;
import 'medical_profile_screen.dart';

// ============================================================
//  COLORS
// ============================================================
const _bg       = Color(0xFF1A1008);
const _cardBg   = Color(0x21000000); // #000000 13% opacity
const _fieldBg  = Color(0x36221910); // #221910 50% opacity
const _orange   = Color(0xFFF27F0D);
const _border   = Color(0xFFF27F0D);
const _txtW     = Color(0xFFF1F5F9);
const _txtGray  = Color(0xFF64748B);

// ============================================================
//  SIGN UP SCREEN
// ============================================================
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _showPass = false;
  bool _showConf = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  void _goToMedical(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (ctx, anim, __) => const MedicalProfileScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
          final fade = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: anim, curve: const Interval(0.0, 0.5)));
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(
          opacity: _fade,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background: صورة الأجهزة ──
              // 🎛️ للتحكم في موضع الصورة: غيري Alignment (x من -1 لـ 1, y من -1 لـ 1)
              //    Alignment(0, 0)   = المنتصف
              //    Alignment(0, 1)   = أسفل
              //    Alignment(0, -1)  = أعلى
              // 🎛️ للتحكم في الحجم: غيري BoxFit
              //    BoxFit.cover   = يملي الشاشة كاملة (الأكبر)
              //    BoxFit.contain = يظهر الصورة كاملة بدون قطع
              //    BoxFit.fitWidth  = يملي العرض بس
              //    BoxFit.fitHeight = يملي الارتفاع بس
              Positioned.fill(
                child: Image.asset(
                  'assets/images/lumos_devices.png',
                  fit: BoxFit.cover,     // ← غيري هنا للتحكم في الحجم
                  alignment: Alignment(0, 0), // ← غيري هنا للتحكم في الموضع
                ),
              ),

              // ── Overlay الغمامة ──
              // 🎛️ للتحكم في كثافة الغمامة: غيري الرقم (0.0 = شفاف، 1.0 = أسود كامل)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.55), // ← الغمامة فوق
                        Colors.black.withOpacity(0.35), // ← المنتصف أخف
                        Colors.black.withOpacity(0.65), // ← الغمامة تحت
                      ],
                    ),
                  ),
                ),
              ),

              // ── Card في المنتصف ──
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: _FormCard(
                    p: p,
                    nameCtrl: _nameCtrl,
                    emailCtrl: _emailCtrl,
                    passCtrl: _passCtrl,
                    confCtrl: _confCtrl,
                    showPass: _showPass,
                    showConf: _showConf,
                    onTogglePass: () => setState(() => _showPass = !_showPass),
                    onToggleConf: () => setState(() => _showConf = !_showConf),
                    onSignUp: () => _goToMedical(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  FORM CARD
// ============================================================
class _FormCard extends StatelessWidget {
  final LocaleProvider p;
  final TextEditingController nameCtrl, emailCtrl, passCtrl, confCtrl;
  final bool showPass, showConf;
  final VoidCallback onTogglePass, onToggleConf, onSignUp;

  const _FormCard({
    required this.p,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.confCtrl,
    required this.showPass,
    required this.showConf,
    required this.onTogglePass,
    required this.onToggleConf,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _orange.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.9), blurRadius: 12),
        ],
      ),
      // backdrop blur effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.black.withOpacity(0.55),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  p.tr('create_acc_title'),
                  style: const TextStyle(
                    color: _orange,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Full name
              _Label(p.tr('full_name')),
              const SizedBox(height: 6),
              _Field(
                controller: nameCtrl,
                hint: p.tr('enter_name'),
                textDirection: p.dir,
              ),
              const SizedBox(height: 16),

              // Email
              _Label(p.tr('email')),
              const SizedBox(height: 6),
              _Field(
                controller: emailCtrl,
                hint: p.tr('enter_email'),
                keyboardType: TextInputType.emailAddress,
                textDirection: p.dir,
              ),
              const SizedBox(height: 16),

              // Password
              _Label(p.tr('password')),
              const SizedBox(height: 6),
              _Field(
                controller: passCtrl,
                hint: p.tr('create_password'),
                obscure: !showPass,
                textDirection: p.dir,
                suffix: GestureDetector(
                  onTap: onTogglePass,
                  child: Icon(
                    showPass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _txtGray, size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Repeat password
              _Label(p.tr('repeat_password')),
              const SizedBox(height: 6),
              _Field(
                controller: confCtrl,
                hint: p.tr('confirm_password'),
                obscure: !showConf,
                textDirection: p.dir,
                suffix: GestureDetector(
                  onTap: onToggleConf,
                  child: Icon(
                    showConf
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _txtGray, size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign up button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    shadowColor: _orange.withOpacity(0.2),
                  ),
                  child: Text(
                    p.tr('sign_up'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Field Label ───────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _txtW,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}

// ── Input Field ───────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextDirection textDirection;

  const _Field({
    required this.controller,
    required this.hint,
    required this.textDirection,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0x36221910),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _orange, width: 1),
      ),
      child: Directionality(
        textDirection: textDirection,
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
              padding: const EdgeInsets.only(right: 12),
              child: suffix,
            )
                : null,
            suffixIconConstraints:
            const BoxConstraints(minWidth: 0, minHeight: 0),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          ),
        ),
      ),
    );
  }
}