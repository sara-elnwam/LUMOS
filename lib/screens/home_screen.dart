// lib/screens/home_screen.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'bracelet_screen.dart';
import 'smart_cane_screen.dart';
import 'earbuds_screen.dart';
import 'smart_glasses_screen.dart';

// ── Colors ────────────────────────────────────────────────────
const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
const _green  = Color(0xFF2FE344);
const _txtW   = Color(0xFFF1F5F9);

// ════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() { _fadeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Scaffold(
      backgroundColor: _bg,
      extendBody: true,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background ────────────────────────────────
            Positioned.fill(
              child: Image.asset(
                'assets/images/lumos_devices.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            // ── Dark overlay gradient ─────────────────────
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.82),
                      Colors.black.withOpacity(0.58),
                      Colors.black.withOpacity(0.90),
                    ],
                  ),
                ),
              ),
            ),
            // ── Content ───────────────────────────────────
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${p.user?.name ?? ''}',
                          style: TextStyle(
                            color: const Color(0xFFFFFFFF).withOpacity(0.60),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Home',
                          style: TextStyle(
                            color: _orange,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // ✅ "4 devices Connected" — Row بدلاً من RichText للمحاذاة الصحيحة
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '4 devices ',
                              style: TextStyle(
                                color: const Color(0xFFFFFFFF).withOpacity(0.60),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Connected',
                              style: TextStyle(
                                color: _green,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── 2×2 Device Grid ──────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 169 / 269,
                        padding: EdgeInsets.only(
                          bottom: 80 + MediaQuery.of(context).padding.bottom,
                        ),
                        children: [
                          _DeviceCard(icon: const _GlassesIcon(), label: 'Smart Glasses',
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const SmartGlassesScreen()))),
                          _DeviceCard(icon: const _CaneIcon(), label: 'Cane',
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const SmartCaneScreen()))),
                          _DeviceCard(icon: const _LumoBandIcon(), label: 'Lumo band',
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const BraceletScreen()))),
                          _DeviceCard(icon: const _EarbudsIcon(), label: 'Earbuds',
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const EarbudsScreen()))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        selected: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  DEVICE CARD — ✅ تخفيف العتمة: opacity 0.60 → 0.35
// ════════════════════════════════════════════════════════════
class _DeviceCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  const _DeviceCard({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withOpacity(0.35), // ✅ خُففت
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 64,
                offset: const Offset(0, 32),
              ),
              BoxShadow(
                color: const Color(0xFFF2F2F2).withOpacity(0.06),
                blurRadius: 22,
                spreadRadius: -4,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              splashColor: _orange.withOpacity(0.08),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFFF8F8F8),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 44, height: 44, child: icon),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  ICONS
// ════════════════════════════════════════════════════════════

class _GlassesIcon extends StatelessWidget {
  const _GlassesIcon();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GlassesPainter(), size: const Size(44, 44));
}

class _GlassesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = _orange
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s.width * 0.03, s.height * 0.28,
              s.width * 0.40, s.height * 0.44),
          Radius.circular(s.height * 0.10),
        ), p);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s.width * 0.57, s.height * 0.28,
              s.width * 0.40, s.height * 0.44),
          Radius.circular(s.height * 0.10),
        ), p);
    canvas.drawLine(Offset(s.width * 0.43, s.height * 0.50),
        Offset(s.width * 0.57, s.height * 0.50), p);
    canvas.drawLine(Offset(s.width * 0.03, s.height * 0.50),
        Offset(0, s.height * 0.50), p);
    canvas.drawLine(Offset(s.width * 0.97, s.height * 0.50),
        Offset(s.width, s.height * 0.50), p);
  }
  @override bool shouldRepaint(_) => false;
}

class _CaneIcon extends StatelessWidget {
  const _CaneIcon();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _CanePainter(), size: const Size(44, 44));
}

class _CanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final stroke = Paint()
      ..color = _orange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = _orange..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(s.width * 0.65, s.height * 0.10),
      Offset(s.width * 0.25, s.height * 0.85),
      stroke,
    );

    final handlePath = Path()
      ..moveTo(s.width * 0.65, s.height * 0.10)
      ..quadraticBezierTo(
        s.width * 0.72, s.height * 0.04,
        s.width * 0.78, s.height * 0.10,
      )
      ..quadraticBezierTo(
        s.width * 0.84, s.height * 0.17,
        s.width * 0.78, s.height * 0.24,
      );
    canvas.drawPath(handlePath, stroke);

    canvas.drawLine(
      Offset(s.width * 0.18, s.height * 0.88),
      Offset(s.width * 0.32, s.height * 0.88),
      stroke..strokeWidth = 2.0,
    );

    canvas.drawCircle(Offset(s.width * 0.25, s.height * 0.85), 3.0, fill);
  }
  @override bool shouldRepaint(_) => false;
}

class _LumoBandIcon extends StatelessWidget {
  const _LumoBandIcon();
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -math.pi / 2,
    child: CustomPaint(painter: _LumoBandPainter(), size: const Size(44, 44)),
  );
}

class _LumoBandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final stroke = Paint()
      ..color = _orange
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = s.width / 2;
    final cy = s.height / 2;
    final r  = s.width * 0.28;
    final sw = r * 0.60;

    canvas.drawCircle(Offset(cx, cy), r, stroke);
    canvas.drawLine(Offset(cx - sw, cy - r), Offset(cx - sw, cy - r - s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx + sw, cy - r), Offset(cx + sw, cy - r - s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx - sw, cy - r - s.height * 0.16), Offset(cx + sw, cy - r - s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx - sw, cy + r), Offset(cx - sw, cy + r + s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx + sw, cy + r), Offset(cx + sw, cy + r + s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx - sw, cy + r + s.height * 0.16), Offset(cx + sw, cy + r + s.height * 0.16), stroke);
    canvas.drawLine(Offset(cx, cy), Offset(cx, cy - r * 0.55), stroke..strokeWidth = 2.0);
    canvas.drawLine(Offset(cx, cy), Offset(cx + r * 0.40, cy), stroke..strokeWidth = 1.5);
    canvas.drawCircle(Offset(cx, cy), 2.0, Paint()..color = _orange..style = PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}

class _EarbudsIcon extends StatelessWidget {
  const _EarbudsIcon();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _EarbudsPainter(), size: const Size(44, 44));
}

class _EarbudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final stroke = Paint()
      ..color = _orange
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _orange..style = PaintingStyle.fill;

    _drawEarbud(canvas, s, s.width * 0.27, stroke, fill);
    _drawEarbud(canvas, s, s.width * 0.73, stroke, fill);
  }

  void _drawEarbud(Canvas canvas, Size s, double cx, Paint stroke, Paint fill) {
    final bw = s.width * 0.19;
    final bh = s.height * 0.33;
    final cy = s.height * 0.38;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: bw, height: bh),
        Radius.circular(bw * 0.55),
      ),
      stroke,
    );
    canvas.drawCircle(Offset(cx, cy - bh * 0.10), bw * 0.22, stroke..strokeWidth = 1.2);
    final stemTop = cy + bh * 0.48;
    final stemBot = cy + bh * 0.90;
    canvas.drawLine(Offset(cx, stemTop), Offset(cx, stemBot), stroke..strokeWidth = 1.8);
    canvas.drawCircle(Offset(cx, stemBot + s.width * 0.048), s.width * 0.052, fill);
  }
  @override bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════
//  BOTTOM NAVIGATION BAR
// ════════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottom,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0A07).withOpacity(0.96),
        border: Border(
          top: BorderSide(color: _orange.withOpacity(0.15), width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBtn(child: _NavHomeIcon(active: selected == 0),     onTap: () => onTap(0)),
            _NavBtn(child: _NavAddIcon(active: selected == 1),      onTap: () => onTap(1)),
            _NavBtn(child: _NavProfileIcon(active: selected == 2),  onTap: () => onTap(2)),
            _NavBtn(child: _NavSettingsIcon(active: selected == 3), onTap: () => onTap(3)),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _NavBtn({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: SizedBox(width: 60, height: 64, child: Center(child: child)),
  );
}

// ════════════════════════════════════════════════════════════
//  ✅ Active wrapper — دايرة عند التفعيل لأي أيقونة
// ════════════════════════════════════════════════════════════
class _ActiveWrapper extends StatelessWidget {
  final bool active;
  final Widget child;
  const _ActiveWrapper({required this.active, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!active) return child;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _orange.withOpacity(0.10),
      ),
      child: CustomPaint(
        painter: _CircleGradientBorderPainter(),
        child: Center(child: child),
      ),
    );
  }
}

// ✅ Gradient border دايري
class _CircleGradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 0.5;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF404040).withOpacity(0.50),
          const Color(0xFF404040).withOpacity(0.35),
          Colors.white.withOpacity(0.50),
          Colors.white.withOpacity(0.50),
          const Color(0xFF404040).withOpacity(0.35),
          const Color(0xFFF9F9F9).withOpacity(0.50),
          Colors.white.withOpacity(0.50),
          const Color(0xFFF9F9F9).withOpacity(0.50),
          const Color(0xFF404040).withOpacity(0.50),
        ],
        stops: const [0.0, 0.12, 0.25, 0.37, 0.50, 0.62, 0.75, 0.87, 1.0],
      ).createShader(rect)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Home icon — ✅ دايرة active
class _NavHomeIcon extends StatelessWidget {
  final bool active;
  const _NavHomeIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    final iconWidget = CustomPaint(
      painter: _HouseNavPainter(active: active),
      size: const Size(20, 20),
    );
    return _ActiveWrapper(active: active, child: iconWidget);
  }
}

class _HouseNavPainter extends CustomPainter {
  final bool active;
  const _HouseNavPainter({required this.active});

  @override
  void paint(Canvas canvas, Size s) {
    final color = active ? _orange : const Color(0xFFF8F8F8);
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(0, s.height * 0.52)
        ..lineTo(s.width * 0.50, 0)
        ..lineTo(s.width, s.height * 0.52),
      p,
    );
    canvas.drawLine(Offset(s.width * 0.14, s.height * 0.52), Offset(s.width * 0.14, s.height), p);
    canvas.drawLine(Offset(s.width * 0.86, s.height * 0.52), Offset(s.width * 0.86, s.height), p);
    canvas.drawLine(Offset(s.width * 0.14, s.height), Offset(s.width * 0.86, s.height), p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width * 0.35, s.height * 0.58, s.width * 0.30, s.height * 0.42),
        const Radius.circular(1),
      ),
      active ? (Paint()..color = color..style = PaintingStyle.fill) : p,
    );
  }

  @override
  bool shouldRepaint(_HouseNavPainter o) => o.active != active;
}

// ✅ Add icon — خطين Vector بدون إطار مربع
class _NavAddIcon extends StatelessWidget {
  final bool active;
  const _NavAddIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    return _ActiveWrapper(
      active: active,
      child: CustomPaint(
        painter: _PlusVectorPainter(active: active),
        size: const Size(22, 22),
      ),
    );
  }
}

class _PlusVectorPainter extends CustomPainter {
  final bool active;
  const _PlusVectorPainter({required this.active});

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = active ? _orange : const Color(0xFFF8F8F8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Horizontal
    canvas.drawLine(Offset(0, s.height / 2), Offset(s.width, s.height / 2), paint);
    // Vertical
    canvas.drawLine(Offset(s.width / 2, 0), Offset(s.width / 2, s.height), paint);
  }

  @override
  bool shouldRepaint(_PlusVectorPainter o) => o.active != active;
}

// ── Profile icon
class _NavProfileIcon extends StatelessWidget {
  final bool active;
  const _NavProfileIcon({required this.active});
  @override
  Widget build(BuildContext context) => _ActiveWrapper(
    active: active,
    child: Icon(
      active ? Icons.person : Icons.person_outline,
      color: active ? _orange : const Color(0xFFF8F8F8),
      size: 24,
    ),
  );
}

// ── Settings icon
class _NavSettingsIcon extends StatelessWidget {
  final bool active;
  const _NavSettingsIcon({required this.active});
  @override
  Widget build(BuildContext context) => _ActiveWrapper(
    active: active,
    child: Icon(
      active ? Icons.settings : Icons.settings_outlined,
      color: active ? _orange : const Color(0xFFF8F8F8),
      size: 24,
    ),
  );
}