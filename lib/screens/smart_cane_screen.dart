// lib/screens/smart_cane_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'medical_profile_screen.dart';
import 'settings_screen.dart';

const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
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

  Future<void> _speakStatus() async {
    final p = context.read<LocaleProvider>();
    final status = _isOn
        ? AppStrings.get(p.langCode, 'cane_connected')
        : AppStrings.get(p.langCode, 'cane_disconnected');
    final battery = AppStrings.get(p.langCode, 'cane_battery');
    final time    = AppStrings.get(p.langCode, 'cane_time');
    await p.speak('$status. $battery. $time.');
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: _bg,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context, p),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. الصورة الخلفية
            Positioned.fill(
              child: Image.asset(
                'assets/images/CANE.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // 2. التدرج اللوني
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            // 3. طبقة مخفية للـ TTS والعودة للهوم
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: _speakStatus,
                  onDoubleTap: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // 4. العناصر التفاعلية (الكارد)
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: _StatusCard(
                      isOn: _isOn,
                      onToggle: (v) {
                        setState(() => _isOn = v);
                        _speakStatus();
                      },
                      p: p,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, LocaleProvider p) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.10)),
              ),
              child: const Icon(Icons.arrow_back, color: _txtW, size: 20),
            ),
          ),
        ),
      ),
      title: Text(
        p.tr('smart_cane'),
        style: GoogleFonts.manrope(
            color: _txtW, fontSize: 17, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;
  final LocaleProvider p;
  const _StatusCard({
    required this.isOn,
    required this.onToggle,
    required this.p,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 305,
          height: 202,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: const Color(0xFFF2F2F2).withOpacity(0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('36%',
                  style: GoogleFonts.manrope(
                      color: _txtW,
                      fontSize: 32,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Text(
                p.tr('battery_time'),
                style: GoogleFonts.manrope(
                    color: _txtW.withOpacity(0.60), fontSize: 12),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    isOn ? p.tr('toggle_on') : p.tr('toggle_off'),
                    style: GoogleFonts.manrope(
                        color: _txtW,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  _CustomToggle(value: isOn, onChanged: onToggle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _CustomToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: _orange,
      activeTrackColor: _orange.withOpacity(0.3),
      inactiveThumbColor: Colors.white.withOpacity(0.4),
      inactiveTrackColor: Colors.white.withOpacity(0.1),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
      color: Colors.transparent,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.home_outlined, 0),
                _buildNavItem(context, Icons.add_circle_outline, 1),
                _buildNavItem(context, Icons.person_outline, 2),
                _buildNavItem(context, Icons.settings_outlined, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isActive = index == 0;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (index == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MedicalProfileScreen()));
        } else if (index == 3) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()));
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFF6A00).withOpacity(0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(
              color: const Color(0xFFFF6A00).withOpacity(0.4), width: 1.2)
              : null,
        ),
        child: Icon(
          icon,
          color: isActive
              ? const Color(0xFFFF6A00)
              : Colors.white.withOpacity(0.45),
          size: 26,
        ),
      ),
    );
  }
}