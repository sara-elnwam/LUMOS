// lib/screens/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider, AppStrings;

// ============================================================
//  COLORS
// ============================================================
const _bg      = Colors.black;
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _fieldBg = Color(0x0DFFFFFF); // white 5%

// ============================================================
//  SIGN IN SCREEN
// ============================================================
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _showPass   = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _signIn() {
    // TODO: real auth
    Navigator.of(context).pushReplacementNamed('/home');
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
              // ── Background image (same as sign-up) ──────────
              Positioned.fill(
                child: Image.asset(
                  'assets/images/lumos_devices.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),

              // ── Dark overlay ─────────────────────────────────
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.80),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Card ─────────────────────────────────────────
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.55),
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Title ──────────────────────────────
                          Center(
                            child: Text(
                              'Welcome back',
                              style: const TextStyle(
                                color: _orange,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Please enter your details to sign in',
                              style: const TextStyle(
                                color: _txtGray,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ── Email ──────────────────────────────
                          _FieldLabel('Email address'),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _emailCtrl,
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // ── Password ───────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _FieldLabel('Password'),
                              GestureDetector(
                                onTap: () {}, // TODO: forgot password
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: _orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _passCtrl,
                            hint: 'Enter your password',
                            obscure: !_showPass,
                            suffix: GestureDetector(
                              onTap: () => setState(() => _showPass = !_showPass),
                              child: Icon(
                                _showPass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _txtGray,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── Sign in button ─────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
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
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _txtW,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );
}

// ── Input Field ───────────────────────────────────────────────
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
            child: suffix,
          )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}