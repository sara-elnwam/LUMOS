// lib/screens/biometrics_screen.dart
//
// ════════════════════════════════════════════════════════════
//  SETUP REQUIRED
// ════════════════════════════════════════════════════════════
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
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider;

// ── Colors ───────────────────────────────────────────────────
const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
const _txtW   = Color(0xFFF1F5F9);
const _txtGray= Color(0xFF94A3B8);
const _trackC = Color(0xFF2A1A08);
const _redC   = Color(0xFFE53935);
const _greenC = Color(0xFF43A047);

enum _S { idle, scanning, lift, success, failed, unavailable }

// ════════════════════════════════════════════════════════════
class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});
  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen>
    with TickerProviderStateMixin {

  final _auth = LocalAuthentication();

  _S     _scan       = _S.idle;
  int    _scansLeft  = 4;   // 4 scans required
  double _progress   = 0.0; // 0.0 → 1.0  (25% per scan)
  String _msg        = 'Place your finger on the sensor to begin';

  // ── animations ───────────────────────────────────────────
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;

  late final AnimationController _successCtrl;
  late final Animation<double>   _successAnim;

  // fills 0 → 0.23 during each scan (stops just before 25% then jumps)
  late final AnimationController _fillCtrl;
  late final Animation<double>   _fillAnim;

  // current scan base (0, 0.25, 0.50, 0.75)
  double _base = 0.0;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _successAnim = CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);

    // each scan animates 0 → 0.22 of the total bar (the 0.25 jump happens on success)
    _fillCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _fillAnim = Tween<double>(begin: 0.0, end: 0.22)
        .animate(CurvedAnimation(parent: _fillCtrl, curve: Curves.easeInOut));

    _fillAnim.addListener(() {
      if (_scan == _S.scanning && mounted) {
        setState(() => _progress = _base + _fillAnim.value);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _nextScan());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _successCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  //  SCAN LOGIC
  // ════════════════════════════════════════════════════════
  Future<void> _nextScan() async {
    if (!mounted) return;

    // check availability first time
    if (_scansLeft == 4) {
      bool canCheck = false;
      List<BiometricType> avail = [];
      try {
        canCheck = await _auth.canCheckBiometrics;
        avail    = await _auth.getAvailableBiometrics();
      } on PlatformException { canCheck = false; }

      if (!canCheck || avail.isEmpty) {
        if (!mounted) return;
        setState(() {
          _scan = _S.unavailable;
          _msg  = 'No biometrics enrolled.\nYou can skip for now.';
        });
        return;
      }
    }

    // update which scan number we're on
    final scanNo = 5 - _scansLeft; // 1,2,3,4
    setState(() {
      _scan = _S.scanning;
      _msg  = _scanMsg(scanNo);
    });

    // animate the fill during waiting
    _fillCtrl.forward(from: 0.0);

    // request fingerprint
    bool ok = false;
    try {
      ok = await _auth.authenticate(
        localizedReason: 'Scan $scanNo of 4 — place your finger',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth:    true,
        ),
      );
    } on PlatformException catch (e) {
      _fillCtrl.stop();
      if (!mounted) return;
      setState(() {
        _scan     = _S.failed;
        _msg      = _errorMsg(e.code);
        _progress = _base; // reset partial fill for this scan
      });
      return;
    }

    if (!mounted) return;
    _fillCtrl.stop();

    if (ok) {
      // animate remaining gap → exactly _base + 0.25
      await _animateTo(_base + 0.25);

      _scansLeft--;

      if (_scansLeft == 0) {
        // ALL 4 DONE
        setState(() {
          _scan = _S.success;
          _msg  = 'Fingerprint verified!';
        });
        _pulseCtrl.stop();
        _successCtrl.forward();
        await _animateTo(1.0);

        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');

      } else {
        // lift finger prompt
        _base = _base + 0.25;
        setState(() {
          _scan = _S.lift;
          _msg  = 'Lift your finger and place it again\n(${_scansLeft} scan${_scansLeft > 1 ? 's' : ''} remaining)';
        });
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) _nextScan();
      }

    } else {
      setState(() {
        _scan     = _S.failed;
        _msg      = 'Authentication failed. Try again.';
        _progress = _base;
      });
    }
  }

  // animate progress smoothly to a target value
  Future<void> _animateTo(double target) async {
    final from = _progress;
    final ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    final anim = Tween<double>(begin: from, end: target)
        .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
    anim.addListener(() { if (mounted) setState(() => _progress = anim.value); });
    await ctrl.forward();
    ctrl.dispose();
  }

  String _scanMsg(int n) {
    switch (n) {
      case 1: return 'Hold still — first scan';
      case 2: return 'Good! Keep going — second scan';
      case 3: return 'Almost there — third scan';
      case 4: return 'Last one! — final scan';
      default: return 'Keep your finger pressed firmly';
    }
  }

  String _errorMsg(String code) {
    switch (code) {
      case 'NotEnrolled':          return 'No fingerprints enrolled.\nAdd one in Settings.';
      case 'LockedOut':            return 'Too many attempts. Please wait.';
      case 'PermanentlyLockedOut': return 'Biometrics locked. Use device PIN.';
      default:                     return 'Something went wrong. Try again.';
    }
  }

  // ── color helpers ─────────────────────────────────────────
  Color get _c {
    if (_scan == _S.success) return _greenC;
    if (_scan == _S.failed)  return _redC;
    return _orange;
  }

  String get _label {
    switch (_scan) {
      case _S.scanning:    return 'Scanning...';
      case _S.lift:        return 'Lift finger ↑';
      case _S.success:     return 'Verified ✓';
      case _S.failed:      return 'Failed ✗';
      case _S.unavailable: return 'Unavailable';
      default:             return 'Ready';
    }
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final c = _c;

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(child: Column(children: [

            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),

                  const Text('Set up Biometrics',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _txtW, fontSize: 32,
                        fontWeight: FontWeight.w800, height: 1.2),
                  ),
                  const SizedBox(height: 12),

                  const Text('Place your finger on the sensor to begin',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _txtGray, fontSize: 17,
                        fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 52),

                  // ── Fingerprint circle ──────────────────
                  AnimatedBuilder(
                    animation: Listenable.merge([_pulseAnim, _successAnim]),
                    builder: (_, __) => SizedBox(
                      width: 270, height: 270,
                      child: Stack(alignment: Alignment.center, children: [

                        Container(
                          width: 270, height: 270,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.withOpacity(0.04),
                            border: Border.all(color: c.withOpacity(0.14), width: 1.5),
                          ),
                        ),

                        CustomPaint(
                          size: const Size(270, 270),
                          painter: _ArcPainter(
                            progress: _progress,
                            color: c,
                            track: c.withOpacity(0.15),
                            stroke: 7,
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 196, height: 196,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [c.withOpacity(0.45), c.withOpacity(0.18), c.withOpacity(0.05)],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            border: Border.all(color: c.withOpacity(0.25), width: 1),
                          ),
                        ),

                        _scan == _S.success
                            ? ScaleTransition(
                          scale: _successAnim,
                          child: const Icon(Icons.check_circle_outline,
                              color: _greenC, size: 90),
                        )
                            : Transform.scale(
                          scale: _scan == _S.scanning ? _pulseAnim.value : 1.0,
                          child: Icon(Icons.fingerprint, color: c, size: 100),
                        ),
                      ]),
                    ),
                  ),

                  const Spacer(),

                  // ── Scan dots (4 steps) ─────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final done = i < (4 - _scansLeft);
                      final active = i == (4 - _scansLeft) && _scan == _S.scanning;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: done || active ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: done
                              ? _greenC
                              : active
                              ? _orange
                              : _orange.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // ── progress section ────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(_label,
                          key: ValueKey(_label),
                          style: TextStyle(color: c, fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text('${(_progress * 100).round()}%',
                        style: const TextStyle(color: _txtW, fontSize: 26,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // segmented progress bar (4 segments)
                  Row(
                    children: List.generate(4, (i) {
                      final segFill = (_progress - i * 0.25).clamp(0.0, 0.25) / 0.25;
                      return Expanded(child: Padding(
                        padding: EdgeInsets.only(right: i < 3 ? 4 : 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: segFill,
                            minHeight: 8,
                            backgroundColor: _trackC,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              segFill >= 1.0 ? _greenC : _orange,
                            ),
                          ),
                        ),
                      ));
                    }),
                  ),
                  const SizedBox(height: 16),

                  Center(child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Text(_msg,
                      key: ValueKey(_msg),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _scan == _S.failed ? _redC : _txtGray,
                        fontSize: 15, height: 1.5,
                      ),
                    ),
                  )),
                  const SizedBox(height: 36),
                ],
              ),
            )),

            // ── bottom button ─────────────────────────────
            Container(
              color: _bg,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
              child: SizedBox(
                width: double.infinity, height: 56,
                child: _bottomBtn(context),
              ),
            ),
          ])),
        ),
      ),
    );
  }

  Widget _bottomBtn(BuildContext ctx) {
    if (_scan == _S.success) {
      return ElevatedButton(
        onPressed: () => Navigator.of(ctx).pushReplacementNamed('/home'),
        style: _bs(_orange),
        child: const Text('DONE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      );
    }
    if (_scan == _S.unavailable) {
      return ElevatedButton(
        onPressed: () => Navigator.of(ctx).pushReplacementNamed('/home'),
        style: _bs(_orange.withOpacity(0.15),
            side: BorderSide(color: _orange), fg: _orange),
        child: const Text('Skip for now',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      );
    }
    if (_scan == _S.failed) {
      return ElevatedButton(
        onPressed: _nextScan,
        style: _bs(_orange),
        child: const Text('Try Again',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );
    }
    return const SizedBox.shrink();
  }

  ButtonStyle _bs(Color bg, {BorderSide? side, Color fg = Colors.black}) =>
      ElevatedButton.styleFrom(
        backgroundColor: bg, foregroundColor: fg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: side ?? BorderSide.none,
        ),
        elevation: 0,
      );
}

// ════════════════════════════════════════════════════════════
//  ARC PAINTER
// ════════════════════════════════════════════════════════════
class _ArcPainter extends CustomPainter {
  final double progress, stroke;
  final Color color, track;
  const _ArcPainter({
    required this.progress, required this.color,
    required this.track,    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - stroke / 2;

    canvas.drawCircle(c, r, Paint()
      ..color = track ..strokeWidth = stroke
      ..style = PaintingStyle.stroke ..strokeCap = StrokeCap.round);

    if (progress > 0.01) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = color ..strokeWidth = stroke
          ..style = PaintingStyle.stroke ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter o) => o.progress != progress || o.color != color;
}