import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../main.dart'
    show LocaleProvider, LumosVoiceService, LumosHaptics, AppStrings;

const _trackC = Color(0xFF2A1A08);
const _redC = Color(0xFFE53935);
const _greenC = Color(0xFF43A047);
const _orangeLogo = Color(0xFFFF9800);
const _bg = Color(0xFF121212);
const _txtW = Colors.white;
const _txtGray = Colors.grey;

enum _ScanState { idle, scanning, lift, success, failed, unavailable }

class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen>
    with TickerProviderStateMixin {
  final _auth = LocalAuthentication();
  final _audioPlayer = AudioPlayer();

  _ScanState _scanState = _ScanState.idle;
  int _scansLeft = 4;
  double _progress = 0.0;
  String _msg = '';

  bool _isSpeaking = false;
  bool _isListening = false;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  late final AnimationController _successCtrl;
  late final Animation<double> _successAnim;
  late final AnimationController _fillCtrl;
  late final Animation<double> _fillAnim;
  double _base = 0.0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _speakInstruction();
  }

  void _initAnimations() {
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _successAnim = CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);

    _fillCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _fillAnim = Tween<double>(begin: 0.0, end: 0.22)
        .animate(CurvedAnimation(parent: _fillCtrl, curve: Curves.easeInOut));

    _fillAnim.addListener(() {
      if (_scanState == _ScanState.scanning && mounted) {
        setState(() => _progress = _base + _fillAnim.value);
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _successCtrl.dispose();
    _fillCtrl.dispose();
    _audioPlayer.dispose();
    LumosVoiceService.instance.stop();
    super.dispose();
  }


  Future<void> _speak(String text, {bool waitForComplete = true}) async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled || text.isEmpty) return;

    _isSpeaking = true;
    if (waitForComplete) {
      await LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
    } else {
      LumosVoiceService.instance.speak(text, lang: p.langCode, gender: p.voiceGender);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _isSpeaking = false;
      });
    }
    _isSpeaking = false;
  }

  Future<void> _speakInstruction() async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    await _speak(AppStrings.get(p.langCode, 'biometrics_instruction'), waitForComplete: true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _scanState == _ScanState.idle) {
        _nextScan();
      }
    });
  }


  Future<void> _nextScan() async {
    if (!mounted) return;

    final p = context.read<LocaleProvider>();
    final scanNumber = 5 - _scansLeft;
    final totalScans = 4;

    await _speak(
      AppStrings.fill(p.langCode, 'biometrics_scan_start', {
        'current': scanNumber.toString(),
        'total': totalScans.toString(),
      }),
      waitForComplete: true,
    );

    if (_scansLeft == 4) {
      bool canCheck = false;
      List<BiometricType> avail = [];
      try {
        canCheck = await _auth.canCheckBiometrics;
        avail = await _auth.getAvailableBiometrics();
      } on PlatformException {
        canCheck = false;
      }

      if (!canCheck || avail.isEmpty) {
        if (!mounted) return;
        setState(() {
          _scanState = _ScanState.unavailable;
          _msg = AppStrings.get(p.langCode, 'biometrics_unavailable');
        });
        _playSound('unavailable');
        await _speak(AppStrings.get(p.langCode, 'biometrics_unavailable'), waitForComplete: true);
        HapticFeedback.mediumImpact();
        return;
      }
    }

    final scanNo = 5 - _scansLeft;
    setState(() {
      _scanState = _ScanState.scanning;
      _msg = _scanMsg(scanNo, p.langCode);
    });
    HapticFeedback.selectionClick();

    _fillCtrl.forward(from: 0.0);

    bool ok = false;
    try {
      ok = await _auth.authenticate(
        localizedReason: AppStrings.fill(p.langCode, 'biometrics_scan_reason', {
          'current': scanNo.toString(),
          'total': '4',
        }),
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      _fillCtrl.stop();
      if (!mounted) return;
      setState(() {
        _scanState = _ScanState.failed;
        _msg = _errorMsg(e.code, p.langCode);
        _progress = _base;
      });
      _playSound('error');
      await _speak(_errorMsg(e.code, p.langCode), waitForComplete: true);
      HapticFeedback.heavyImpact();
      return;
    }

    if (!mounted) return;
    _fillCtrl.stop();

    if (ok) {
      _playSound('success');
      HapticFeedback.lightImpact();

      await _animateTo(_base + 0.25);

      _scansLeft--;

      if (_scansLeft == 0) {
        setState(() {
          _scanState = _ScanState.success;
          _msg = AppStrings.get(p.langCode, 'biometrics_success');
        });
        _pulseCtrl.stop();
        _successCtrl.forward();
        _playSound('complete');
        await _speak(AppStrings.get(p.langCode, 'biometrics_complete'), waitForComplete: true);
        HapticFeedback.heavyImpact();

        await _animateTo(1.0);
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _base = _base + 0.25;
        await _speak(
          AppStrings.fill(p.langCode, 'biometrics_lift_finger', {
            'remaining': _scansLeft.toString(),
          }),
          waitForComplete: true,
        );

        setState(() {
          _scanState = _ScanState.lift;
          _msg = AppStrings.fill(p.langCode, 'biometrics_lift_message', {
            'remaining': _scansLeft.toString(),
          });
        });

        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) _nextScan();
      }
    } else {
      setState(() {
        _scanState = _ScanState.failed;
        _msg = AppStrings.get(p.langCode, 'biometrics_failed');
        _progress = _base;
      });
      _playSound('error');
      await _speak(AppStrings.get(p.langCode, 'biometrics_failed'), waitForComplete: true);
      HapticFeedback.vibrate();
    }
  }

  Future<void> _playSound(String type) async {
    try {
      switch (type) {
        case 'success':
          await _audioPlayer.play(AssetSource('sounds/scan_success.mp3'));
          break;
        case 'error':
          await _audioPlayer.play(AssetSource('sounds/scan_error.mp3'));
          break;
        case 'complete':
          await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
          break;
        case 'unavailable':
          await _audioPlayer.play(AssetSource('sounds/unavailable.mp3'));
          break;
      }
    } catch (e) {}
  }

  Future<void> _animateTo(double target) async {
    final from = _progress;
    final ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    final anim = Tween<double>(begin: from, end: target)
        .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
    anim.addListener(() {
      if (mounted) setState(() => _progress = anim.value);
    });
    await ctrl.forward();
    ctrl.dispose();
  }

  String _scanMsg(int n, String lang) {
    switch (n) {
      case 1: return AppStrings.get(lang, 'biometrics_scan_1');
      case 2: return AppStrings.get(lang, 'biometrics_scan_2');
      case 3: return AppStrings.get(lang, 'biometrics_scan_3');
      case 4: return AppStrings.get(lang, 'biometrics_scan_4');
      default: return AppStrings.get(lang, 'biometrics_scan_default');
    }
  }

  String _errorMsg(String code, String lang) {
    switch (code) {
      case 'NotEnrolled': return AppStrings.get(lang, 'biometrics_error_not_enrolled');
      case 'LockedOut': return AppStrings.get(lang, 'biometrics_error_locked');
      case 'PermanentlyLockedOut': return AppStrings.get(lang, 'biometrics_error_permanent');
      default: return AppStrings.get(lang, 'biometrics_error_default');
    }
  }

  Color get _color {
    if (_scanState == _ScanState.success) return _greenC;
    if (_scanState == _ScanState.failed) return _redC;
    return _orangeLogo;
  }

  String get _label {
    final p = context.read<LocaleProvider>();
    switch (_scanState) {
      case _ScanState.scanning: return AppStrings.get(p.langCode, 'biometrics_status_scanning');
      case _ScanState.lift: return AppStrings.get(p.langCode, 'biometrics_status_lift');
      case _ScanState.success: return AppStrings.get(p.langCode, 'biometrics_status_success');
      case _ScanState.failed: return AppStrings.get(p.langCode, 'biometrics_status_failed');
      case _ScanState.unavailable: return AppStrings.get(p.langCode, 'biometrics_status_unavailable');
      default: return AppStrings.get(p.langCode, 'biometrics_status_ready');
    }
  }


  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final c = _color;

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Text(
                          AppStrings.get(p.langCode, 'biometrics_title'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _txtW,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _msg.isEmpty ? AppStrings.get(p.langCode, 'biometrics_place_finger') : _msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _txtGray,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 52),
                        AnimatedBuilder(
                          animation: Listenable.merge([_pulseAnim, _successAnim]),
                          builder: (_, __) => SizedBox(
                            width: 270,
                            height: 270,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 270,
                                  height: 270,
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
                                  width: 196,
                                  height: 196,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [c.withOpacity(0.45), c.withOpacity(0.18), c.withOpacity(0.05)],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                    border: Border.all(color: c.withOpacity(0.25), width: 1),
                                  ),
                                ),
                                _scanState == _ScanState.success
                                    ? ScaleTransition(
                                  scale: _successAnim,
                                  child: Icon(Icons.check_circle_outline, color: _greenC, size: 90),
                                )
                                    : Transform.scale(
                                  scale: _scanState == _ScanState.scanning ? _pulseAnim.value : 1.0,
                                  child: Icon(Icons.fingerprint, color: c, size: 100),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            final done = i < (4 - _scansLeft);
                            final active = i == (4 - _scansLeft) && _scanState == _ScanState.scanning;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: done || active ? 32 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: done ? _greenC : active ? _orangeLogo : _orangeLogo.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _label,
                                key: ValueKey(_label),
                                style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Text(
                              '${(_progress * 100).round()}%',
                              style: const TextStyle(color: _txtW, fontSize: 26, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(4, (i) {
                            final segFill = (_progress - i * 0.25).clamp(0.0, 0.25) / 0.25;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: i < 3 ? 4 : 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: segFill,
                                    minHeight: 8,
                                    backgroundColor: _trackC,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      segFill >= 1.0 ? _greenC : _orangeLogo,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: _bg,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
                  child: _bottomBtn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBtn(BuildContext ctx) {
    final p = context.read<LocaleProvider>();

    if (_scanState == _ScanState.success) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(ctx).pushReplacementNamed('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _orangeLogo,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            AppStrings.get(p.langCode, 'biometrics_done_button'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.2),
          ),
        ),
      );
    }
    if (_scanState == _ScanState.unavailable) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(ctx).pushReplacementNamed('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _orangeLogo.withOpacity(0.15),
            foregroundColor: _orangeLogo,
            side: const BorderSide(color: _orangeLogo),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            AppStrings.get(p.langCode, 'biometrics_skip_button'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    if (_scanState == _ScanState.failed) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _nextScan();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _orangeLogo,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            AppStrings.get(p.langCode, 'biometrics_tryagain_button'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ArcPainter extends CustomPainter {
  final double progress, stroke;
  final Color color, track;
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - stroke / 2;

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = track
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0.01) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = color
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter o) => o.progress != progress || o.color != color;
}