// lib/screens/bracelet_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector;
import 'bracelets_list_screen.dart';
import 'medical_profile_screen.dart';
import 'settings_screen.dart';

const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
const _txtW   = Color(0xFFF8F8F8);

class BraceletScreen extends StatefulWidget {
  const BraceletScreen({super.key});
  @override
  State<BraceletScreen> createState() => _BraceletScreenState();
}

class _BraceletScreenState extends State<BraceletScreen>
    with SingleTickerProviderStateMixin {
  bool _isOn = true;
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late final ShakeDetector _shake;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    _shake = ShakeDetector(onShake: _onShake);
    _shake.start();

    WidgetsBinding.instance.addPostFrameCallback((_) => _speakIntro());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _shake.stop();
    super.dispose();
  }

  Future<void> _speakIntro() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode) return;
    await LumosVoiceService.instance.speak(
      p.tr('earbuds_screen') + '. ' + p.tr('battery_36') + '. ' + p.tr('tap_toggle_to_change'),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  Future<void> _onShake() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode) return;
    await LumosHaptics.heartbeat();
    await LumosVoiceService.instance.speak(
      p.fill('shake_help', {
        'screen': p.tr('lumo_band_screen'),
        'hint': p.tr('battery_36') + '. ' + p.tr('time_remaining_3h'),
      }),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  Future<void> _toggle(bool v) async {
    setState(() => _isOn = v);
    await LumosHaptics.tick();
    final p = context.read<LocaleProvider>();
    if (p.isVoiceMode) {
      await LumosVoiceService.instance.speak(
        v ? p.tr('lumo_band_on') : p.tr('lumo_band_off'),
        lang: p.langCode, gender: p.voiceGender,
      );
    }
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
            Positioned.fill(
              child: Image.asset(
                'assets/images/lumos_devices.png', fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => Container(color: _bg),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.92),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: _speakIntro,
                  onDoubleTap: () {
                    LumosHaptics.tick();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const SizedBox.expand(),
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
                    child: _StatusCard(isOn: _isOn, onToggle: _toggle, p: p),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: Image.asset(
                        'assets/images/bracelet.png', fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  _ShowBraceletsBtn(
                    onTap: () {
                      LumosHaptics.tick();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const BraceletsListScreen()));
                    },
                    p: p,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(p: p),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, LocaleProvider p) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: GestureDetector(
        onTap: () { LumosHaptics.tick(); Navigator.pop(context); },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: _txtW, size: 16),
          ),
        ),
      ),
      title: Text(p.tr('lumo_band'), style: GoogleFonts.manrope(
          color: _txtW, fontSize: 18, fontWeight: FontWeight.w600)),
      centerTitle: true,
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;
  final LocaleProvider p;

  const _StatusCard({required this.isOn, required this.onToggle, required this.p});

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
            color: Colors.black.withOpacity(0.10),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF393535).withOpacity(0.41), width: 1),
            boxShadow: [
              BoxShadow(color: const Color(0xFFF2F2F2).withOpacity(0.06), blurRadius: 22, spreadRadius: -4),
              BoxShadow(color: Colors.black.withOpacity(0.23), blurRadius: 21.21, spreadRadius: -3.75, offset: const Offset(10, 10)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('36%', style: GoogleFonts.manrope(color: _txtW, fontSize: 32, fontWeight: FontWeight.w500, height: 1.0)),
              const SizedBox(height: 8),
              Container(height: 1, color: _orange.withOpacity(0.50)),
              const SizedBox(height: 10),
              Text(p.tr('time_remaining_3h'),
                  style: GoogleFonts.manrope(color: _txtW.withOpacity(0.80), fontSize: 12,
                      fontWeight: FontWeight.w400, letterSpacing: 0.12, height: 1.0)),
              const SizedBox(height: 16),
              Row(children: [
                GestureDetector(
                  onTap: () => onToggle(!isOn),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: GoogleFonts.jetBrainsMono(
                      color: isOn ? const Color(0xFFDADADA) : _txtW.withOpacity(0.40),
                      fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 0.24, height: 1.0,
                    ),
                    child: Text(isOn ? p.tr('toggle_on') : p.tr('toggle_off')),
                  ),
                ),
                const SizedBox(width: 14),
                _OrangeToggle(value: isOn, onChanged: onToggle),
              ]),
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
        width: 52, height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? const Color(0xFF952B00).withOpacity(0.53) : Colors.white.withOpacity(0.10),
        ),
        child: Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            left: value ? 26 : 2, top: 2,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? const Color(0xFFF27F0D) : Colors.white.withOpacity(0.35),
                boxShadow: value ? [BoxShadow(color: const Color(0xFFF27F0D).withOpacity(0.55), blurRadius: 10, spreadRadius: 1)] : [],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ShowBraceletsBtn extends StatelessWidget {
  final VoidCallback onTap;
  final LocaleProvider p;

  const _ShowBraceletsBtn({required this.onTap, required this.p});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 221, height: 56,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF393535).withOpacity(0.41), width: 1),
              boxShadow: [BoxShadow(color: const Color(0xFFF2F2F2).withOpacity(0.06), blurRadius: 22, spreadRadius: -4)],
            ),
            child: Center(
              child: Text(
                p.fill('show_bracelets', {'count': '4'}),
                style: GoogleFonts.manrope(color: _orange, fontSize: 18,
                    fontWeight: FontWeight.w700, letterSpacing: -0.45, height: 1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final LocaleProvider p;
  const _BottomNav({required this.p});

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
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1,
          ),
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
    bool isActive = index == 0;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicalProfileScreen()),
          );
        }
        else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF27F0D).withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: const Color(0xFFF27F0D).withOpacity(0.4), width: 1.2)
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFF27F0D) : Colors.white.withOpacity(0.45),
          size: 26,
        ),
      ),
    );
  }
}