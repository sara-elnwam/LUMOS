// lib/screens/qr_profile_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/voice_service.dart';
import '../main.dart' show GlowPainter, VoiceHintBanner;

// ============================================================
//  COLORS
// ============================================================
const _bg      = Color(0xFF1A1008);
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _cardBg  = Color(0xFF140F0A);

// ============================================================
//  QR PROFILE SCREEN
// ============================================================
class QrProfileScreen extends StatefulWidget {
  const QrProfileScreen({super.key});
  @override
  State<QrProfileScreen> createState() => _QrProfileScreenState();
}

class _QrProfileScreenState extends State<QrProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  int _tapCount = 0;
  Timer? _tapTimer;

  // ── Localization strings per screen ──────────────────────
  // Each screen owns its own L10n section
  static const Map<String, Map<String, String>> _l10n = {
    'en': {
      'title':    'Your Profile Card',
      'subtitle': 'Share this QR with emergency responders.',
      'name':     'Name',
      'sex':      'Sex',
      'blood':    'Blood Type',
      'allergies':'Allergies',
      'meds':     'Medications',
      'diseases': 'Diseases',
      'none':     'None',
      'share':    'Share QR',
      'continue': 'Continue',
      'tap1':     '1 tap = Share  ·  2 taps = Continue',
      // TTS
      'tts_intro':    'Your medical profile QR card is ready. Tap once to share it. Tap twice to continue to biometrics setup.',
      'tts_sharing':  'Opening share menu.',
    },
    'ar': {
      'title':    'بطاقة ملفك الشخصي',
      'subtitle': 'شارك هذا الرمز مع خدمات الطوارئ.',
      'name':     'الاسم',
      'sex':      'الجنس',
      'blood':    'فصيلة الدم',
      'allergies':'الحساسية',
      'meds':     'الأدوية',
      'diseases': 'الأمراض',
      'none':     'لا يوجد',
      'share':    'مشاركة QR',
      'continue': 'متابعة',
      'tap1':     'ضغطة = مشاركة  ·  ضغطتان = متابعة',
      'tts_intro':    'بطاقة QR الطبية جاهزة. اضغط مرة لمشاركتها. اضغط مرتين للمتابعة إلى إعداد البصمة.',
      'tts_sharing':  'فتح قائمة المشاركة.',
    },
    'es': {
      'title':    'Tu Tarjeta de Perfil',
      'subtitle': 'Comparte este QR con los servicios de emergencia.',
      'name':     'Nombre',
      'sex':      'Sexo',
      'blood':    'Tipo de sangre',
      'allergies':'Alergias',
      'meds':     'Medicamentos',
      'diseases': 'Enfermedades',
      'none':     'Ninguno',
      'share':    'Compartir QR',
      'continue': 'Continuar',
      'tap1':     '1 toque = Compartir  ·  2 toques = Continuar',
      'tts_intro':    'Tu tarjeta QR médica está lista. Toca una vez para compartirla. Toca dos veces para continuar a la configuración biométrica.',
      'tts_sharing':  'Abriendo menú de compartir.',
    },
    'fr': {
      'title':    'Votre Carte de Profil',
      'subtitle': 'Partagez ce QR avec les secouristes.',
      'name':     'Nom',
      'sex':      'Sexe',
      'blood':    'Groupe sanguin',
      'allergies':'Allergies',
      'meds':     'Médicaments',
      'diseases': 'Maladies',
      'none':     'Aucun',
      'share':    'Partager QR',
      'continue': 'Continuer',
      'tap1':     '1 tap = Partager  ·  2 taps = Continuer',
      'tts_intro':    'Votre carte QR médicale est prête. Appuyez une fois pour la partager. Appuyez deux fois pour continuer à la configuration biométrique.',
      'tts_sharing':  'Ouverture du menu de partage.',
    },
    'de': {
      'title':    'Ihre Profilkarte',
      'subtitle': 'Teilen Sie diesen QR mit Ersthelfern.',
      'name':     'Name',
      'sex':      'Geschlecht',
      'blood':    'Blutgruppe',
      'allergies':'Allergien',
      'meds':     'Medikamente',
      'diseases': 'Erkrankungen',
      'none':     'Keine',
      'share':    'QR teilen',
      'continue': 'Weiter',
      'tap1':     '1 Tippen = Teilen  ·  2 Tippen = Weiter',
      'tts_intro':    'Ihre medizinische QR-Karte ist fertig. Einmal tippen zum Teilen. Zweimal tippen um zur biometrischen Einrichtung fortzufahren.',
      'tts_sharing':  'Teilen-Menü öffnen.',
    },
    'ja': {
      'title':    'プロフィールカード',
      'subtitle': 'このQRを救急スタッフと共有してください。',
      'name':     '名前',
      'sex':      '性別',
      'blood':    '血液型',
      'allergies':'アレルギー',
      'meds':     '薬',
      'diseases': '疾患',
      'none':     'なし',
      'share':    'QRを共有',
      'continue': '続ける',
      'tap1':     '1回タップ = 共有  ·  2回タップ = 続ける',
      'tts_intro':    'あなたの医療QRカードが準備できました。一度タップして共有。二度タップして生体認証の設定に進みます。',
      'tts_sharing':  '共有メニューを開きます。',
    },
  };

  String _t(String lang, String key) =>
      _l10n[lang]?[key] ?? _l10n['en']![key] ?? key;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      if (p.isVoiceMode) {
        VoiceService().speak(
          _t(p.langCode, 'tts_intro'),
          lang: p.langCode,
          gender: p.voiceGender,
        );
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _tapTimer?.cancel();
    VoiceService().stop();
    super.dispose();
  }

  // ── Voice tap detection ───────────────────────────────────
  void _onScreenTap() {
    final p = context.read<AppProvider>();
    if (!p.isVoiceMode) return;
    _tapCount++;
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 500), () {
      final taps = _tapCount;
      _tapCount = 0;
      if (taps == 1) _shareQr(p);
      else if (taps >= 2) _continue();
    });
  }

  Future<void> _shareQr(AppProvider p) async {
    await VoiceService().speak(
      _t(p.langCode, 'tts_sharing'),
      lang: p.langCode,
      gender: p.voiceGender,
    );
    _doShare(p);
  }

  void _doShare(AppProvider p) {
    final m = p.medical;
    final name     = Uri.encodeComponent(p.user?.name ?? '');
    final sex      = Uri.encodeComponent(m.sex);
    final blood    = Uri.encodeComponent(m.bloodType);
    final allergies = Uri.encodeComponent(m.allergies.join(', '));
    final meds     = Uri.encodeComponent(m.medications.join(', '));
    final diseases  = Uri.encodeComponent(m.diseases.join(', '));

    // Share as a readable link — emergency responders can open it in any browser
    final link =
        'https://lumos.app/profile'
        '?name=$name'
        '&sex=$sex'
        '&blood=$blood'
        '&allergies=$allergies'
        '&meds=$meds'
        '&diseases=$diseases';

    Share.share(
      link,
      subject: 'Lumos Medical Profile — ${p.user?.name ?? ''}',
    );
  }

  /// Builds a shareable URL from the user's medical profile.
  /// The QR code encodes this URL so any QR scanner opens it directly in a browser.
  String _buildProfileLink(AppProvider p) {
    final m = p.medical;
    final name      = Uri.encodeComponent(p.user?.name ?? '');
    final sex       = Uri.encodeComponent(m.sex);
    final blood     = Uri.encodeComponent(m.bloodType);
    final allergies = Uri.encodeComponent(m.allergies.join(', '));
    final meds      = Uri.encodeComponent(m.medications.join(', '));
    final diseases  = Uri.encodeComponent(m.diseases.join(', '));
    return 'https://lumos.app/profile'
        '?name=$name'
        '&sex=$sex'
        '&blood=$blood'
        '&allergies=$allergies'
        '&meds=$meds'
        '&diseases=$diseases';
  }

  void _continue() {
    Navigator.of(context).pushReplacementNamed('/biometrics');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final lang = p.langCode;
    final medical = p.medical;
    final qrData = _buildProfileLink(p);

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onTap: _onScreenTap,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Background glow ─────────────────────
                Positioned.fill(
                  child: CustomPaint(painter: const GlowPainter()),
                ),

                // ── Content ─────────────────────────────
                SafeArea(
                  child: Column(
                    children: [
                      // ── Header ──────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          children: [
                            Text(
                              _t(lang, 'title'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _orange,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _t(lang, 'subtitle'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _txtGray,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── QR Code ──────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _orange.withOpacity(0.25),
                              blurRadius: 30,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF1A1008),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF1A1008),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Medical Summary Card ──────────
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _MedicalSummaryCard(
                            medical: medical,
                            userName: p.user?.name ?? '',
                            lang: lang,
                            t: _t,
                          ),
                        ),
                      ),

                      // ── Voice hint ───────────────────
                      if (p.isVoiceMode)
                        VoiceHintBanner(hint: _t(lang, 'tap1')),

                      // ── Buttons ──────────────────────
                      if (!p.isVoiceMode) _ManualButtons(
                        shareLabel: _t(lang, 'share'),
                        continueLabel: _t(lang, 'continue'),
                        onShare: () => _doShare(p),
                        onContinue: _continue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  MEDICAL SUMMARY CARD
// ============================================================
class _MedicalSummaryCard extends StatelessWidget {
  final MedicalProfile medical;
  final String userName;
  final String lang;
  final String Function(String, String) t;

  const _MedicalSummaryCard({
    required this.medical,
    required this.userName,
    required this.lang,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _orange.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(t(lang, 'name'),      userName),
          _row(t(lang, 'sex'),       medical.sex.isEmpty ? t(lang, 'none') : medical.sex),
          _row(t(lang, 'blood'),     medical.bloodType.isEmpty ? t(lang, 'none') : medical.bloodType),
          _row(t(lang, 'allergies'), medical.allergies.isEmpty ? t(lang, 'none') : medical.allergies.join(', ')),
          _row(t(lang, 'meds'),      medical.medications.isEmpty ? t(lang, 'none') : medical.medications.join(', ')),
          _row(t(lang, 'diseases'),  medical.diseases.isEmpty ? t(lang, 'none') : medical.diseases.join(', '), last: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool last = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(
                  color: _txtGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: _txtW,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (!last) ...[
          const SizedBox(height: 8),
          Divider(color: _orange.withOpacity(0.12), height: 1),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

// ============================================================
//  MANUAL MODE BUTTONS
// ============================================================
class _ManualButtons extends StatelessWidget {
  final String shareLabel;
  final String continueLabel;
  final VoidCallback onShare;
  final VoidCallback onContinue;

  const _ManualButtons({
    required this.shareLabel,
    required this.continueLabel,
    required this.onShare,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
          top: BorderSide(color: _orange.withOpacity(0.20), width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 20 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          // Share button
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text(shareLabel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _orange,
                  side: BorderSide(color: _orange.withOpacity(0.60)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Continue button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  continueLabel,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}