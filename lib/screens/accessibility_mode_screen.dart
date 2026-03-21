// lib/screens/accessibility_mode_screen.dart
//
// ════════════════════════════════════════════════════════════
//  ACCESSIBILITY MODE SCREEN
//
//  أول شاشة في الـ onboarding — المستخدم يختار manual أو voice
//
//  التدفق:
//    1. TTS يرحب بالمستخدم ويشرح الشاشة بلغة الموبايل الحالية
//    2. المستخدم يضغط على كارت (Manual فوق / Voice تحت)
//    3. TTS يقوله "اخترت X، اضغط تاني للتأكيد"
//    4. الكارت يبقى highlighted ← يضغط عليه تاني للتأكيد
//    5. لو اختار Manual → مفيش TTS بعد كده، يكمل بصمت
//    6. لو اختار Voice → يكمل لشاشة اختيار اللغة
// ════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/voice_service.dart';
import '../l10n/app_strings.dart';

const _bg      = Color(0xFF1A1008);
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);

// ════════════════════════════════════════════════════════════
class AccessibilityModeScreen extends StatefulWidget {
  const AccessibilityModeScreen({super.key});
  @override
  State<AccessibilityModeScreen> createState() => _AccessibilityModeScreenState();
}

class _AccessibilityModeScreenState extends State<AccessibilityModeScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _anim;
  late final Animation<double> _fade;
  String _deviceLang = 'en';

  // ── Confirmation state ────────────────────────────────────
  // null = no selection yet
  // 'manual' or 'voice' = waiting for confirmation tap
  String? _pendingMode;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();

    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    const supported = ['en', 'ar', 'es', 'fr', 'de', 'ja'];
    _deviceLang = supported.contains(locale.languageCode) ? locale.languageCode : 'en';

    WidgetsBinding.instance.addPostFrameCallback((_) => _speakWelcome());
  }

  Future<void> _speakWelcome() async {
    await VoiceService().speak(
      AppStrings.get(_deviceLang, 'tts_screen_acc'),
      lang: _deviceLang,
    );
    await VoiceService().speak(
      AppStrings.get(_deviceLang, 'tts_acc_welcome'),
      lang: _deviceLang,
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    VoiceService().stop();
    super.dispose();
  }

  // ── Called when user first taps a card ───────────────────
  Future<void> _onCardTap(String mode) async {
    // If already pending this mode → confirm immediately
    if (_pendingMode == mode) {
      await _confirmMode(mode);
      return;
    }

    // New selection → announce and wait for second tap
    _pendingMode = mode;
    setState(() {});
    VoiceService().stop();

    final modeLabel = mode == 'manual'
        ? AppStrings.get(_deviceLang, 'acc_manual')
        : AppStrings.get(_deviceLang, 'acc_voice');

    await VoiceService().speak(
      AppStrings.fill(_deviceLang, 'tts_acc_selected', {'mode': modeLabel}),
      lang: _deviceLang,
    );
  }

  // ── Called when user taps the same card a second time ────
  Future<void> _confirmMode(String mode) async {
    _pendingMode = null;
    setState(() {});
    VoiceService().stop();

    final p = context.read<AppProvider>();
    await p.setInteractionMode(mode);
    if (mode == 'voice') await p.setLang(_deviceLang);

    if (mounted) Navigator.of(context).pushReplacementNamed('/choose-language');
  }

  // ── Cancel pending selection ──────────────────────────────
  void _cancelPending() {
    _pendingMode = null;
    setState(() {});
    _speakWelcome();
  }

  @override
  Widget build(BuildContext context) {
    final s = (String k) => AppStrings.get(_deviceLang, k);
    final isRTL = AppStrings.isRTL(_deviceLang);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _bg,
        body: FadeTransition(
          opacity: _fade,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: CustomPaint(painter: _GlowPainter())),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ── Icon + Title ──────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _orange.withOpacity(0.12),
                            border: Border.all(color: _orange.withOpacity(0.35), width: 1.5),
                          ),
                          child: const Icon(Icons.accessibility_new_rounded, color: _orange, size: 36),
                        ),
                        const SizedBox(height: 24),
                        Text(s('acc_title'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: _txtW, fontSize: 28, fontWeight: FontWeight.w800, height: 1.25, letterSpacing: -0.5)),
                        const SizedBox(height: 12),
                        Text(s('acc_subtitle'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: _txtGray, fontSize: 15, fontWeight: FontWeight.w400, height: 1.55)),
                      ]),
                    ),

                    const Spacer(flex: 2),

                    // ── Mode Cards ────────────────────────
                    // كارت Manual فوق، كارت Voice تحت
                    // المسافة الكبيرة بينهم تساعد المستخدم الأعمى يعرف
                    // "فوق = manual" و"تحت = voice"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(children: [

                        // ── Manual (فوق) ──────────────────
                        _ModeCard(
                          icon: Icons.touch_app_rounded,
                          title: s('acc_manual'),
                          subtitle: s('acc_manual_sub'),
                          isPending: _pendingMode == 'manual',
                          onTap: () => _onCardTap('manual'),
                        ),

                        // مسافة كبيرة بين الكارتين
                        const SizedBox(height: 36),

                        // ── Voice (تحت) ───────────────────
                        _ModeCard(
                          icon: Icons.spatial_audio_off_rounded,
                          title: s('acc_voice'),
                          subtitle: s('acc_voice_sub'),
                          isPending: _pendingMode == 'voice',
                          onTap: () => _onCardTap('voice'),
                        ),

                        // ── Confirmation hint (يظهر بعد أول ضغطة) ──
                        if (_pendingMode != null) ...[
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _cancelPending,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _orange.withOpacity(0.30)),
                              ),
                              child: Text(
                                s('acc_confirm_hint'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: _txtGray, fontSize: 13, height: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ]),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  MODE CARD
//  — isPending = true → الكارت highlighted في انتظار التأكيد
//  — ضغطة أولى → pending + TTS يعلن الاختيار
//  — ضغطة تانية على نفس الكارت → confirm
// ════════════════════════════════════════════════════════════
class _ModeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isPending;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isPending = false,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = _pressed || widget.isPending;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: highlighted
              ? _orange.withOpacity(0.14)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? _orange : _orange.withOpacity(0.22),
            width: highlighted ? 1.8 : 1,
          ),
          boxShadow: highlighted
              ? [BoxShadow(color: _orange.withOpacity(0.18), blurRadius: 22, spreadRadius: -2, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon box
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56, height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: highlighted ? _orange.withOpacity(0.20) : Colors.white.withOpacity(0.07),
                border: Border.all(
                  color: highlighted ? _orange.withOpacity(0.55) : Colors.white.withOpacity(0.10),
                  width: 1,
                ),
              ),
              child: Icon(widget.icon, color: highlighted ? _orange : _txtGray, size: 28),
            ),
            const SizedBox(width: 18),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                        color: highlighted ? _orange : _txtW,
                        fontSize: 18, fontWeight: FontWeight.w700, height: 1.2,
                      )),
                  const SizedBox(height: 5),
                  Text(widget.subtitle,
                      style: const TextStyle(color: _txtGray, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5)),
                ],
              ),
            ),

            // Arrow / Checkmark
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isPending
                  ? const Icon(Icons.check_circle_rounded, key: ValueKey('check'), color: _orange, size: 22)
                  : Icon(Icons.arrow_forward_ios_rounded, key: const ValueKey('arrow'),
                  color: _pressed ? _orange : _txtGray.withOpacity(0.50), size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  GLOW BACKGROUND
// ════════════════════════════════════════════════════════════
class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, size.width * 0.7,
        Paint()..shader = RadialGradient(
          colors: [const Color(0xFFF27F0D).withOpacity(0.10), Colors.transparent], radius: 0.6,
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: size.width * 0.7)));
    canvas.drawCircle(Offset(size.width, size.height), size.width * 0.6,
        Paint()..shader = RadialGradient(
          colors: [const Color(0xFFF27F0D).withOpacity(0.07), Colors.transparent], radius: 0.5,
        ).createShader(Rect.fromCircle(center: Offset(size.width, size.height), radius: size.width * 0.6)));
  }
  @override
  bool shouldRepaint(_) => false;
}