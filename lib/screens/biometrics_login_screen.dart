// lib/screens/biometrics_login_screen.dart
//
// ════════════════════════════════════════════════════════════
//  شاشة البصمة عند تسجيل الدخول — بعد الـ Sign In مباشرة
//  الديزاين: WELCOME BACK + دايرة بصمة + "Touch the sensor"
//           + زر "Use Password Instead"
// ════════════════════════════════════════════════════════════
//
//  SETUP REQUIRED (لو مش موجودة خلاص):
//  1) pubspec.yaml:
//       local_auth: ^2.3.0
//     then: flutter pub get
//
//  2) android/app/src/main/kotlin/.../MainActivity.kt
//       class MainActivity: FlutterFragmentActivity()
//
//  3) android/app/src/main/AndroidManifest.xml (before <application>):
//       <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
//       <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
//
//  4) ios/Runner/Info.plist:
//       <key>NSFaceIDUsageDescription</key>
//       <string>Used to verify your identity</string>
// ════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// ── Colors (نفس باليت الأب) ──────────────────────────────────
const _bg      = Color(0xFF0D0A07);
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _redC    = Color(0xFFE53935);
const _greenC  = Color(0xFF43A047);

// ════════════════════════════════════════════════════════════
class BiometricsLoginScreen extends StatefulWidget {
  const BiometricsLoginScreen({super.key});

  @override
  State<BiometricsLoginScreen> createState() => _BiometricsLoginScreenState();
}

enum _State { idle, scanning, success, failed, unavailable }

class _BiometricsLoginScreenState extends State<BiometricsLoginScreen>
    with TickerProviderStateMixin {

  final _auth = LocalAuthentication();
  _State _st  = _State.idle;
  String _msg = 'Touch the sensor';

  // ── pulse animation (النبضة البرتقالية) ─────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;

  // ── glow animation (الإضاءة الخارجية) ───────────────────
  late final AnimationController _glowCtrl;
  late final Animation<double>   _glowAnim;

  // ── success scale ────────────────────────────────────────
  late final AnimationController _successCtrl;
  late final Animation<double>   _successAnim;

  // ── fade in ──────────────────────────────────────────────
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.90, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _successAnim =
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);

    // ابدأ البصمة تلقائي
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _glowCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  //  AUTHENTICATE
  // ════════════════════════════════════════════════════════
  Future<void> _authenticate() async {
    if (!mounted) return;

    // تأكد إن الجهاز يدعم البصمة
    bool canCheck = false;
    List<BiometricType> avail = [];
    try {
      canCheck = await _auth.canCheckBiometrics;
      avail    = await _auth.getAvailableBiometrics();
    } on PlatformException {
      canCheck = false;
    }

    if (!canCheck || avail.isEmpty) {
      if (!mounted) return;
      setState(() {
        _st  = _State.unavailable;
        _msg = 'No biometrics available on this device';
      });
      return;
    }

    setState(() {
      _st  = _State.scanning;
      _msg = 'Touch the sensor';
    });

    bool ok = false;
    try {
      ok = await _auth.authenticate(
        localizedReason: 'Place your finger to sign in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth:    true,
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _st  = _State.failed;
        _msg = _errMsg(e.code);
      });
      return;
    }

    if (!mounted) return;

    if (ok) {
      _pulseCtrl.stop();
      _glowCtrl.stop();
      _successCtrl.forward();
      setState(() {
        _st  = _State.success;
        _msg = 'Verified!';
      });
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _st  = _State.failed;
        _msg = 'Authentication failed. Try again.';
      });
    }
  }

  String _errMsg(String code) {
    switch (code) {
      case 'NotAvailable':      return 'Biometrics not available';
      case 'NotEnrolled':       return 'No fingerprints enrolled';
      case 'LockedOut':         return 'Too many attempts. Try later.';
      case 'PermanentlyLockedOut': return 'Biometrics locked. Use password.';
      default:                  return 'Authentication error. Try again.';
    }
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final Color ringColor = _st == _State.success
        ? _greenC
        : _st == _State.failed
        ? _redC
        : _orange;

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              // ── WELCOME BACK ─────────────────────────────
              const SizedBox(height: 48),
              const Text(
                'WELCOME BACK',
                style: TextStyle(
                  color: _orange,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),

              // ── Subtitle ─────────────────────────────────
              const SizedBox(height: 8),
              const Text(
                'Sign in with your fingerprint',
                style: TextStyle(
                  color: _txtGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              // ── Biometric Circle ─────────────────────────
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnim, _glowAnim]),
                builder: (_, __) {
                  final glowOpacity = _st == _State.scanning
                      ? _glowAnim.value
                      : _st == _State.success
                      ? 1.0
                      : 0.4;
                  final scale = _st == _State.scanning
                      ? _pulseAnim.value
                      : 1.0;

                  return Transform.scale(
                    scale: scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ── Outer glow ──────────────────
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ringColor.withOpacity(0.35 * glowOpacity),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),

                        // ── Dashed border ring ──────────
                        CustomPaint(
                          size: const Size(220, 220),
                          painter: _DashedCirclePainter(
                            color: ringColor.withOpacity(0.7),
                            strokeWidth: 2.0,
                            dashCount: 40,
                          ),
                        ),

                        // ── Inner dark circle ───────────
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1008),
                            gradient: RadialGradient(
                              colors: [
                                ringColor.withOpacity(0.20 * glowOpacity),
                                const Color(0xFF1A1008),
                              ],
                              stops: const [0.0, 0.7],
                            ),
                          ),
                        ),

                        // ── Icon ────────────────────────
                        _st == _State.success
                            ? ScaleTransition(
                          scale: _successAnim,
                          child: Icon(Icons.check_circle_outline,
                              color: _greenC, size: 90),
                        )
                            : Icon(
                          Icons.fingerprint,
                          color: ringColor,
                          size: 100,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(),

              // ── "Touch the sensor" message ───────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _msg,
                  key: ValueKey(_msg),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _st == _State.failed
                        ? _redC
                        : _st == _State.success
                        ? _greenC
                        : _txtW,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ── "Use Password Instead" button ────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _st == _State.failed
                  // بعد الفشل: زر Try Again + Use Password
                      ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _authenticate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Try Again',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PasswordBtn(
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed('/sign-in'),
                        ),
                      ),
                    ],
                  )
                  // الحالة الطبيعية: فقط زر Use Password
                      : _PasswordBtn(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed('/sign-in'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Use Password Instead Button ───────────────────────────────
class _PasswordBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _PasswordBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: _orange.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _orange.withOpacity(0.55), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline, color: _orange, size: 18),
            SizedBox(width: 8),
            Text(
              'Use Password Instead',
              style: TextStyle(
                color: _orange,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  DASHED CIRCLE PAINTER  (الدائرة المتقطعة من الديزاين)
// ════════════════════════════════════════════════════════════
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius  = size.width / 2 - strokeWidth;

    final totalAngle   = 2 * math.pi;
    final dashAngle    = totalAngle / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * 2 * dashAngle - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter o) =>
      o.color != color || o.strokeWidth != strokeWidth;
}