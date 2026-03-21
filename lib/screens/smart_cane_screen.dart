// lib/screens/smart_cane_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFFF6A00);
const _txtW   = Color(0xFFF8F8F8);

class SmartCaneScreen extends StatefulWidget {
  const SmartCaneScreen({super.key});
  @override
  State<SmartCaneScreen> createState() => _SmartCaneScreenState();
}

class _SmartCaneScreenState extends State<SmartCaneScreen>
    with SingleTickerProviderStateMixin {
  bool _isOn = true;
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() { _fadeCtrl.dispose(); super.dispose(); }

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
            Positioned.fill(
              child: Image.asset(
                'assets/images/CANE.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => Container(color: _bg),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.92),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: _StatusCard(
                      isOn: _isOn,
                      onToggle: (v) => setState(() => _isOn = v),
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(height: 36),
                ],
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
        'Smart Cane',
        style: GoogleFonts.manrope(
          color: _txtW,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 24 / 17,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;
  const _StatusCard({required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 202),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF393535).withOpacity(0.41),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF2F2F2).withOpacity(0.06),
                blurRadius: 22,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.23),
                blurRadius: 21.21,
                spreadRadius: -3.75,
                offset: const Offset(10, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '36%',
                style: GoogleFonts.manrope(
                  color: _txtW,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                height: 1,
                color: _orange.withOpacity(0.50),
              ),
              const SizedBox(height: 10),

              Text(
                'Estimated time remaining : 3h 20m',
                style: GoogleFonts.manrope(
                  color: _txtW.withOpacity(0.80),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.12,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => onToggle(!isOn),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      style: GoogleFonts.jetBrainsMono(
                        color: isOn
                            ? const Color(0xFFDADADA)
                            : _txtW.withOpacity(0.40),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.24,
                        height: 1.0,
                      ),
                      child: Text(isOn ? 'On' : 'Off'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  _OrangeToggle(value: isOn, onChanged: onToggle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrangeToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _OrangeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? const Color(0xFF952B00).withOpacity(0.53)
              : Colors.white.withOpacity(0.10),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              left: value ? 26 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? const Color(0xFFFF6A00)
                      : Colors.white.withOpacity(0.35),
                  boxShadow: value
                      ? [
                    BoxShadow(
                      color: const Color(0xFFFF6A00).withOpacity(0.55),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                      : [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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