// lib/screens/bracelets_list_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFFF6A00);
const _txtW   = Color(0xFFF8F8F8);
const _green  = Color(0xFF2FE344);

class BraceletsListScreen extends StatefulWidget {
  const BraceletsListScreen({super.key});
  @override
  State<BraceletsListScreen> createState() => _BraceletsListScreenState();
}

class _BraceletsListScreenState extends State<BraceletsListScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late List<_SensorData> _sensors;

  @override
  void initState() {
    super.initState();
    _sensors = [
      _SensorData(label: 'Left Hand Sensor',  connected: true),
      _SensorData(label: 'Right Hand Sensor', connected: true),
      _SensorData(label: 'Left Leg Sensor',   connected: false),
      _SensorData(label: 'Right leg Sensor',  connected: true),
    ];
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() { _fadeCtrl.dispose(); super.dispose(); }

  void _toggleSensor(int index) {
    setState(() {
      _sensors[index] = _SensorData(
        label:     _sensors[index].label,
        connected: !_sensors[index].connected,
      );
    });
  }

  int get _connectedCount => _sensors.where((s) => s.connected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background ──────────────────────────────
            Positioned.fill(
              child: Image.asset(
                'assets/images/lumos_devices.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => Container(color: _bg),
              ),
            ),
            // ── Dark gradient overlay (نفس bracelet_screen) ─
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.92),
                    ],
                  ),
                ),
              ),
            ),
            // ── Content ─────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title — Manrope ExtraBold 28px orange ─
                    Text(
                      'Bracelets',
                      style: GoogleFonts.manrope(
                        color: _orange,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // ── Connected count ───────────────────
                    Row(
                      children: [
                        Text(
                          '$_connectedCount devices ',
                          style: GoogleFonts.manrope(
                            color: _txtW.withOpacity(0.60),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Connected',
                          style: GoogleFonts.manrope(
                            color: _green,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // ── Grid — 2 cols, 169×269 per card ──
                    Expanded(
                      child: GridView.builder(
                        itemCount: _sensors.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 169 / 269,
                        ),
                        padding: EdgeInsets.only(
                          bottom: 80 + MediaQuery.of(context).padding.bottom,
                        ),
                        itemBuilder: (_, i) => _SensorCard(
                          data: _sensors[i],
                          onTap: () => _toggleSensor(i),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // سهم الرجوع — نفس شكل bracelet_screen
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _txtW, size: 16),
          ),
        ),
      ),
      title: Text(
        'bracelet',
        style: GoogleFonts.manrope(
          color: _txtW,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _SensorData {
  final String label;
  final bool   connected;
  const _SensorData({required this.label, required this.connected});
}

// ═══════════════════════════════════════════════════════════════
//  SENSOR CARD
//  Figma: 169×269, radius 24, #000000 10%, blur 12
//  Label:  Manrope SemiBold 600 16px #F8F8F8 center
//  Status: JetBrains Mono ExtraBold 800 15px
//          Connected=#FF6B01 / Disconnected=#F8F8F8 35%
//  بدون أيقون — الضغط يغيّر Connected ↔ Disconnected
// ═══════════════════════════════════════════════════════════════
class _SensorCard extends StatelessWidget {
  final _SensorData  data;
  final VoidCallback onTap;
  const _SensorCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: data.connected
                    ? _orange.withOpacity(0.18)
                    : Colors.white.withOpacity(0.07),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF2F2F2).withOpacity(0.05),
                  blurRadius: 22,
                  spreadRadius: -4,
                ),
                if (data.connected)
                  BoxShadow(
                    color: _orange.withOpacity(0.06),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label — Manrope SemiBold 600 16px
                  Text(
                    data.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _txtW,
                      height: 22.6 / 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Status — JetBrains Mono ExtraBold 800 15px
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: data.connected
                          ? const Color(0xFFFF6B01)
                          : _txtW.withOpacity(0.35),
                      height: 1.0,
                    ),
                    child: Text(
                      data.connected ? 'Connected' : 'Disconnected',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  BOTTOM NAV
// ════════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  const _BottomNav();
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
          children: const [
            Icon(Icons.home_rounded,      color: _orange,           size: 24),
            Icon(Icons.add,               color: Color(0xFFF8F8F8), size: 24),
            Icon(Icons.person_outline,    color: Color(0xFFF8F8F8), size: 24),
            Icon(Icons.settings_outlined, color: Color(0xFFF8F8F8), size: 24),
          ],
        ),
      ),
    );
  }
}