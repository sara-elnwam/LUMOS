// lib/screens/settings_screen.dart
// ════════════════════════════════════════════════════════════
//  SETTINGS SCREEN  — FULL LOCALIZATION
// ════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../main.dart' show LocaleProvider, LumosVoiceService, LumosHaptics, ShakeDetector, AppStrings;

// ── Colors ─────────────────────────────────────────────────
const _bg     = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
const _card   = Color(0xFF1A1008);
const _txtW   = Color(0xFFF1F5F9);
const _txtG   = Color(0xFF94A3B8);

// ════════════════════════════════════════════════════════════
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ShakeDetector _shake;

  @override
  void initState() {
    super.initState();
    _shake = ShakeDetector(onShake: _onShake);
    _shake.start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakIntro());
  }

  @override
  void dispose() {
    _shake.stop();
    super.dispose();
  }

  Future<void> _speakIntro() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode) return;
    await LumosVoiceService.instance.speak(
      p.tr('settings_screen_desc'),
      lang: p.langCode,
      gender: p.voiceGender,
    );
  }

  Future<void> _onShake() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode) return;
    await LumosHaptics.heartbeat();
    await _speakIntro();
  }

  Future<void> _speakAndNavigate(String labelKey, String route) async {
    final p = context.read<LocaleProvider>();
    await LumosHaptics.tick();
    if (p.isVoiceMode) {
      await LumosVoiceService.instance.speak(
        p.fill('opening', {'label': p.tr(labelKey)}),
        lang: p.langCode,
        gender: p.voiceGender,
      );
    }
    if (mounted) Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            LumosHaptics.tick();
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: _txtW, size: 16),
          ),
        ),
        title: Text(
          p.tr('settings'),
          style: const TextStyle(color: _txtW, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _SectionGroup(
            children: [
              _SettingsTile(
                icon: Icons.person_rounded,
                label: p.tr('account'),
                onTap: () => _speakAndNavigate('account', '/account'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.medical_information_rounded,
                label: p.tr('medical_profile'),
                onTap: () => _speakAndNavigate('medical_profile', '/medical-profile'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.language_rounded,
                label: p.tr('language'),
                onTap: () => _speakAndNavigate('language', '/language'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.update_rounded,
                label: p.tr('updates'),
                subtitle: 'New version available',
                subtitleColor: _orange,
                onTap: () => _speakAndNavigate('updates', '/updates'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                label: p.tr('help_feedback'),
                onTap: () => _speakAndNavigate('help_feedback', '/help'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: p.tr('about_lumos'),
                onTap: () => _speakAndNavigate('about_lumos', '/about'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionGroup(
            children: [
              _SettingsTileSwitch(
                icon: Icons.mic_rounded,
                label: p.tr('voice_mode'),
                value: p.isVoiceMode,
                onChanged: (v) {
                  p.setVoiceMode(v);
                  LumosHaptics.tick();
                  if (v) {
                    LumosVoiceService.instance.speak(
                      p.isRTL ? 'تم تفعيل وضع الصوت' : 'Voice mode enabled',
                      lang: p.langCode, gender: p.voiceGender,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _SettingsBottomNav(
        onProfileTap: () => _showProfileSheet(context),
        p: p,
      ),
    );
  }

  static void _showProfileSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileSheet(),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PROFILE BOTTOM SHEET
// ════════════════════════════════════════════════════════════
class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet();

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<LocaleProvider>(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _orange.withOpacity(0.18), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                p.tr('profile'),
                style: const TextStyle(color: _txtW, fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _ProfileCard(
                    icon: Icons.person_rounded,
                    title: p.tr('account'),
                    subtitle: p.tr('personal_info_security'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/account');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProfileCard(
                    icon: Icons.medical_information_rounded,
                    title: p.tr('medical_profile'),
                    subtitle: p.tr('health_data_records'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/medical-profile');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // User info card - get from provider/user storage
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _orange.withOpacity(0.15), width: 1),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _orange, width: 2),
                    color: _orange.withOpacity(0.10),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.person, color: _orange, size: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    p.userName.isNotEmpty ? p.userName : 'User',
                    style: const TextStyle(color: _txtW, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text('user@example.com', style: TextStyle(color: _txtG, fontSize: 12)),
                ]),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: _txtG, size: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PROFILE CARD
// ════════════════════════════════════════════════════════════
class _ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _orange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _orange.withOpacity(0.25), width: 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(color: _txtW, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: _txtG, fontSize: 11, height: 1.4)),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SECTION GROUP
// ════════════════════════════════════════════════════════════
class _SectionGroup extends StatelessWidget {
  final List<Widget> children;
  const _SectionGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _orange.withOpacity(0.12), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SETTINGS TILE
// ════════════════════════════════════════════════════════════
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.label, this.subtitle, this.subtitleColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: _orange.withOpacity(0.06),
        highlightColor: _orange.withOpacity(0.04),
        onTap: () { HapticFeedback.selectionClick(); onTap?.call(); },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(color: _txtW, fontSize: 15, fontWeight: FontWeight.w500)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: TextStyle(color: subtitleColor ?? _txtG, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: _txtG, size: 20),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SETTINGS TILE SWITCH
// ════════════════════════════════════════════════════════════
class _SettingsTileSwitch extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTileSwitch({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: const TextStyle(color: _txtW, fontSize: 15, fontWeight: FontWeight.w500))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: _orange,
          activeTrackColor: _orange.withOpacity(0.30),
          inactiveThumbColor: Colors.white.withOpacity(0.40),
          inactiveTrackColor: Colors.white.withOpacity(0.10),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  DIVIDER
// ════════════════════════════════════════════════════════════
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1, thickness: 1, indent: 68, endIndent: 0,
      color: Colors.white.withOpacity(0.06),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  BOTTOM NAVIGATION
// ════════════════════════════════════════════════════════════
class _SettingsBottomNav extends StatelessWidget {
  final VoidCallback onProfileTap;
  final LocaleProvider p;

  const _SettingsBottomNav({required this.onProfileTap, required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 55),
      color: Colors.transparent,
      child: Container(
        height: 55,
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
                _buildBtn(context, Icons.home_outlined, 0),
                _buildBtn(context, Icons.add_circle_outline, 1),
                _buildBtn(context, Icons.person_outline, 2),
                _buildBtn(context, Icons.settings_rounded, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, IconData icon, int index) {
    bool isActive = index == 3;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (index == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (index == 2) {
          onProfileTap();
        }
      },
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF27F0D).withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: isActive ? Border.all(color: const Color(0xFFF27F0D).withOpacity(0.4), width: 1.2) : null,
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