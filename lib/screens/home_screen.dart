// lib/screens/home_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'
    show LocaleProvider, AppStrings, LumosVoiceService, LumosHaptics, ShakeDetector;
import 'bracelet_screen.dart';
import 'smart_cane_screen.dart';
import 'earbuds_screen.dart';
import 'smart_glasses_screen.dart';
import 'settings_screen.dart';

const _bg    = Color(0xFF0D0A07);
const _orange = Color(0xFFF27F0D);
const _green  = Color(0xFF2FE344);
const _txtW   = Color(0xFFF8F8F8);

const _kGeminiKey = 'AIzaSyBD80rG6SCb6MC1vtefumIFrCIyCAsSNOg';

const _deviceKeywords = {
  'glasses': 'glasses', 'smart glasses': 'glasses',
  'cane': 'cane', 'smart cane': 'cane',
  'bracelet': 'bracelet', 'lumo band': 'bracelet', 'band': 'bracelet',
  'earbuds': 'earbuds', 'earbud': 'earbuds',
  'settings': 'settings',
  'نظارة': 'glasses', 'نظارات': 'glasses', 'النظارة': 'glasses',
  'عصا': 'cane', 'عكاز': 'cane', 'العصا': 'cane',
  'سوار': 'bracelet', 'لومو باند': 'bracelet', 'السوار': 'bracelet',
  'سماعة': 'earbuds', 'سماعات': 'earbuds', 'السماعات': 'earbuds',
  'إعدادات': 'settings',
};
const _kDevices = [
  {
    'key': 'glasses',
    'en': 'Smart Glasses', 'ar': 'النظارة الذكية',
    'es': 'Gafas Inteligentes', 'fr': 'Lunettes Intelligentes',
    'de': 'Intelligente Brille', 'ja': 'スマートグラス',
  },
  {
    'key': 'cane',
    'en': 'Smart Cane', 'ar': 'العصا الذكية',
    'es': 'Bastón Inteligente', 'fr': 'Canne Intelligente',
    'de': 'Intelligenter Stock', 'ja': 'スマート白杖',
  },
  {
    'key': 'bracelet',
    'en': 'Lumo Band', 'ar': 'لومو باند',
    'es': 'Lumo Band', 'fr': 'Lumo Band',
    'de': 'Lumo Band', 'ja': 'ルモバンド',
  },
  {
    'key': 'earbuds',
    'en': 'Earbuds', 'ar': 'السماعات',
    'es': 'Auriculares', 'fr': 'Écouteurs',
    'de': 'Ohrhörer', 'ja': 'イヤーバッズ',
  },
];


class UserStorage {
  static const _kWelcome = 'welcomeSpoken';

  static Future<void> saveUserData({
    required String name, required bool isLoggedIn,
    required String langCode, required String voiceGender,
    required bool hasCompletedReg,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('userName', name);
    await p.setBool('isLoggedIn', isLoggedIn);
    await p.setBool('hasCompletedReg', hasCompletedReg);
    await p.setString('langCode', langCode);
    await p.setString('voiceGender', voiceGender);
    await p.setBool('isFirstTime', false);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final p = await SharedPreferences.getInstance();
    return {
      'userName': p.getString('userName') ?? '',
      'isLoggedIn': p.getBool('isLoggedIn') ?? false,
      'hasCompletedReg': p.getBool('hasCompletedReg') ?? false,
      'langCode': p.getString('langCode') ?? 'en',
      'voiceGender': p.getString('voiceGender') ?? 'female',
    };
  }

  static Future<Map<String, bool>> getDeviceStates() async {
    final p = await SharedPreferences.getInstance();
    return {
      'glasses':  p.getBool('device_glasses')  ?? true,
      'cane':     p.getBool('device_cane')      ?? true,
      'bracelet': p.getBool('device_bracelet')  ?? true,
      'earbuds':  p.getBool('device_earbuds')   ?? true,
    };
  }

  static Future<bool> isWelcomeSpoken() async =>
      (await SharedPreferences.getInstance()).getBool(_kWelcome) ?? false;

  static Future<void> setWelcomeSpoken(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_kWelcome, v);
}

String _getSpeakText(String lang) {
  switch (lang) {
    case 'ar': return 'تكلم...';
    case 'es': return 'Habla...';
    case 'fr': return 'Parlez...';
    case 'de': return 'Sprechen Sie...';
    case 'ja': return '話してください...';
    default: return 'Speak...';
  }
}

String _getListeningText(String lang) {
  switch (lang) {
    case 'ar': return 'جاري الاستماع...';
    case 'es': return 'Escuchando...';
    case 'fr': return 'Écoute...';
    case 'de': return 'Höre zu...';
    case 'ja': return '聞いています...';
    default: return 'Listening...';
  }
}

String _getThinkingText(String lang) {
  switch (lang) {
    case 'ar': return 'لوموس يفكر...';
    case 'es': return 'Lumos está pensando...';
    case 'fr': return 'Lumos réfléchit...';
    case 'de': return 'Lumos denkt nach...';
    case 'ja': return 'Lumosは考え中...';
    default: return 'Lumos is thinking...';
  }
}

String _getNoInputText(String lang) {
  switch (lang) {
    case 'ar': return 'لم أسمع شيئاً، حاول مرة أخرى';
    case 'es': return 'No escuché nada, por favor intenta de nuevo';
    case 'fr': return 'Je n\'ai rien entendu, veuillez réessayer';
    case 'de': return 'Ich habe nichts gehört, bitte versuchen Sie es erneut';
    case 'ja': return '聞こえませんでした。もう一度お試しください';
    default: return "I didn't hear anything, please try again";
  }
}

String _getWelcomeText(String lang, String name) {
  switch (lang) {
    case 'ar': return 'أهلاً وسهلاً، $name';
    case 'es': return 'Bienvenido, $name';
    case 'fr': return 'Bienvenue, $name';
    case 'de': return 'Willkommen, $name';
    case 'ja': return 'ようこそ、$name';
    default: return 'Welcome, $name';
  }
}

String _getConnectedCountText(String lang, int count) {
  switch (lang) {
    case 'ar': return '$count أجهزة متصلة';
    case 'es': return '$count dispositivos conectados';
    case 'fr': return '$count appareils connectés';
    case 'de': return '$count Geräte verbunden';
    case 'ja': return '$count台のデバイスが接続済み';
    default: return '$count devices Connected';
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  String _userName = '';
  Map<String, bool> _connected = {
    'glasses': true, 'cane': true, 'bracelet': true, 'earbuds': true,
  };
  int get _connectedCount => _connected.values.where((v) => v).length;

  bool _isListening = false;
  bool _isThinking  = false;
  OverlayEntry? _overlay;
  Timer? _tapDebounce;
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _refreshDeviceStates();
    _loadUser();
    _shakeDetector = ShakeDetector(onShake: _onShake)..start();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  Future<void> _loadUser() async {
    final d = await UserStorage.getUserData();
    final name = d['userName'] as String? ?? '';
    final spoken = await UserStorage.isWelcomeSpoken();
    if (mounted) setState(() => _userName = name);
    if (!spoken && name.isNotEmpty) {
      final p = context.read<LocaleProvider>();
      Future.delayed(const Duration(milliseconds: 500), () async {
        await LumosVoiceService.instance.speak(
          _getWelcomeText(p.langCode, name),
          lang: p.langCode, gender: p.voiceGender,
        );
        await UserStorage.setWelcomeSpoken(true);
      });
    }
  }

  Future<void> _refreshDeviceStates() async {
    final s = await UserStorage.getDeviceStates();
    if (mounted) setState(() => _connected = s);
  }

  @override
  void dispose() {
    _shakeDetector?.stop();
    _removeOverlay();
    _tapDebounce?.cancel();
    LumosVoiceService.instance.stop();
    super.dispose();
  }

  Future<void> _onQuadrantTap(int idx) async {
    final p     = context.read<LocaleProvider>();
    final d     = _kDevices[idx];
    final key   = d['key']!;
    final label = d[p.langCode] ?? d['en']!;

    await LumosHaptics.tick();

    LumosVoiceService.instance.speak(label, lang: p.langCode, gender: p.voiceGender);
    _navigateTo(key, p);
  }

  Future<void> _onShake() async {
    final p = context.read<LocaleProvider>();
    await LumosHaptics.heartbeat();
    await LumosVoiceService.instance.speak(
      _getConnectedCountText(p.langCode, _connectedCount),
      lang: p.langCode, gender: p.voiceGender,
    );
  }

  Future<void> _onLongPress() async {
    final p = context.read<LocaleProvider>();
    if (_isListening || _isThinking) return;

    _showOverlay(_listeningOverlay(p));
    setState(() => _isListening = true);

    await LumosVoiceService.instance.speak(
      _getSpeakText(p.langCode),
      lang: p.langCode, gender: p.voiceGender,
    );

    final cmd = await LumosVoiceService.instance.listen(lang: p.langCode);
    setState(() => _isListening = false);
    _removeOverlay();

    if (cmd.trim().isEmpty) {
      await LumosVoiceService.instance.speak(
        _getNoInputText(p.langCode),
        lang: p.langCode, gender: p.voiceGender,
      );
      return;
    }

    final dev = _detectDevice(cmd.toLowerCase());
    if (dev != null) { _navigateTo(dev, p); return; }

    _showOverlay(_thinkingOverlay(p));
    setState(() => _isThinking = true);
    final ans = await _askGemini(cmd, p);
    setState(() => _isThinking = false);
    _removeOverlay();

    if (ans.isNotEmpty) {
      _showOverlay(_answerOverlay(ans, p));
      await LumosVoiceService.instance
          .speak(ans, lang: p.langCode, gender: p.voiceGender);
      await Future.delayed(const Duration(seconds: 5));
      _removeOverlay();
    }
  }

  String? _detectDevice(String t) {
    for (final e in _deviceKeywords.entries) {
      if (t.contains(e.key)) return e.value;
    }
    return null;
  }

  void _navigateTo(String key, LocaleProvider p) {
    Widget s;
    switch (key) {
      case 'glasses':  s = const SmartGlassesScreen(); break;
      case 'cane':     s = const SmartCaneScreen();    break;
      case 'bracelet': s = const BraceletScreen();     break;
      case 'earbuds':  s = const EarbudsScreen();      break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => s));
  }

  Future<String> _askGemini(String q, LocaleProvider p) async {
    try {
      const model = 'gemini-1.5-flash';
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_kGeminiKey';
      final prompt = p.langCode == 'ar'
          ? "أنت مساعد ذكي اسمك لوموس في تطبيق إمكانية الوصول. أجب باختصار شديد (جملة واحدة بحد أقصى): $q"
          : "You are Lumos, a smart assistant in an accessibility app. Answer very briefly (maximum one sentence): $q";

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": prompt}]
          }],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 80,
            "topP": 0.95,
          }
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (answer != null && answer.isNotEmpty) {
          debugPrint('[Gemini] ✅ Success! Response: $answer');
          return answer;
        }
      }

      if (response.statusCode == 429) {
        debugPrint('[Gemini] ⚠️ Rate limit exceeded');
        return p.langCode == 'ar'
            ? 'وصلت للحد الأقصى من الطلبات. انتظر دقيقة ثم حاول مرة أخرى.'
            : 'Rate limit reached. Please wait a minute.';
      }

      if (response.statusCode == 403 || response.statusCode == 401) {
        debugPrint('[Gemini] ❌ Authentication failed - Key may be invalid');
        return p.langCode == 'ar'
            ? 'مشكلة في مفتاح API. يرجى تحديث المفتاح.'
            : 'API key issue. Please update your key.';
      }

      debugPrint('[Gemini] HTTP ${response.statusCode}: ${response.body}');

    } on TimeoutException {
      debugPrint('[Gemini] ⏰ Timeout');
      return p.langCode == 'ar'
          ? 'الإنترنت بطيء، حاول مرة أخرى.'
          : 'Internet is slow, please try again.';
    } catch (e) {
      debugPrint('[Gemini] ❌ Error: $e');
    }

    return p.langCode == 'ar'
        ? 'عذراً، لم أستطع الإجابة حالياً. تأكد من اتصالك بالإنترنت.'
        : 'Sorry, I cannot answer right now. Check your internet connection.';
  }

  void _showOverlay(Widget child) {
    _removeOverlay();
    _overlay = OverlayEntry(
      builder: (_) => Stack(children: [
        Positioned.fill(
            child: GestureDetector(onTap: _removeOverlay,
                child: Container(color: Colors.transparent))),
        Positioned(bottom: 100, left: 20, right: 20,
            child: Material(color: Colors.transparent, child: child)),
      ]),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() { _overlay?.remove(); _overlay = null; }

  Widget _listeningOverlay(LocaleProvider p) => _overlayBox(
    Row(mainAxisSize: MainAxisSize.min, children: [
      _WaveAnimIcon(color: _orange), const SizedBox(width: 12),
      Text(_getListeningText(p.langCode),
          style: const TextStyle(color: _orange, fontSize: 16, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _thinkingOverlay(LocaleProvider p) => _overlayBox(
    Row(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(width: 24, height: 24,
          child: CircularProgressIndicator(color: _orange, strokeWidth: 2.5)),
      const SizedBox(width: 12),
      Text(_getThinkingText(p.langCode),
          style: const TextStyle(color: _orange, fontSize: 16, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _answerOverlay(String text, LocaleProvider p) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.9),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: _orange.withOpacity(0.5), width: 1),
    ),
    child: Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: p.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.auto_awesome_rounded, color: _orange, size: 20),
          const SizedBox(width: 8),
          Text('Lumos', style: TextStyle(color: _orange, fontWeight: FontWeight.w800, fontSize: 16)),
        ]),
        const SizedBox(height: 12),
        Text(text, textDirection: p.isRTL ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(color: _txtW, fontSize: 15, height: 1.4),
            maxLines: 6, overflow: TextOverflow.ellipsis),
      ],
    ),
  );

  Widget _overlayBox(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.85),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: _orange.withOpacity(0.5), width: 1),
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final isRTL = p.isRTL;

    return Scaffold(
      backgroundColor: _bg,
      extendBody: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final screenH = constraints.maxHeight;

          final imgAspect = 706.0 / 1534.0;
          double imgW, imgH;
          if (screenW / screenH < imgAspect) {
            imgW = screenW;
            imgH = screenW / imgAspect;
          } else {
            imgH = screenH;
            imgW = screenH * imgAspect;
          }

          final imgLeft = (screenW - imgW) / 2;
          final imgTop = 0.0;
          const double row1Top = 0.45;
          const double row2Top = 0.75;
          const double leftColCenter = 0.28;
          const double rightColCenter = 0.72;

          Rect getRect(double centerX, double topY) {
            final x = imgLeft + (imgW * centerX) - 60;
            final y = imgTop + (imgH * topY);
            final w = 120.0;
            final h = 50.0;
            return Rect.fromLTWH(x, y, w, h);
          }

          final positions = [
            getRect(leftColCenter, row1Top),
            getRect(rightColCenter, row1Top),
            getRect(leftColCenter, row2Top),
            getRect(rightColCenter, row2Top),
          ];
          const headerH = 110.0;
          final tapAreaH = screenH - headerH;
          final tapAreaW = screenW;
          final halfW = tapAreaW / 2;
          final halfH = tapAreaH / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/home_background.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(color: _bg),
                ),
              ),
              Positioned(
                top: headerH,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _onQuadrantTap(0),
                              onLongPress: _onLongPress,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _onQuadrantTap(1),
                              onLongPress: _onLongPress,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _onQuadrantTap(2),
                              onLongPress: _onLongPress,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _onQuadrantTap(3),
                              onLongPress: _onLongPress,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(4, (i) {
                final rect = positions[i];
                final device = _kDevices[i];
                final label = device[p.langCode] ?? device['en']!;

                return Positioned(
                  left: rect.left,
                  top: rect.top,
                  width: rect.width,
                  height: rect.height,
                  child: IgnorePointer(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _txtW,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SafeArea(
                child: Directionality(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_userName.isNotEmpty)
                          Text(
                            _welcome(p.langCode, _userName),
                            style: TextStyle(
                              color: _txtW.withOpacity(0.6), fontSize: 17,
                              fontWeight: FontWeight.w800, fontFamily: 'Manrope',
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _homeLabel(p.langCode),
                          style: const TextStyle(
                            color: _orange, fontSize: 32,
                            fontWeight: FontWeight.w800, fontFamily: 'Manrope',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text(
                            _devicesText(p.langCode),
                            style: TextStyle(
                              color: _txtW.withOpacity(0.6), fontSize: 17,
                              fontWeight: FontWeight.w800, fontFamily: 'Manrope',
                            ),
                          ),
                          Text(
                            _connectedWord(p.langCode),
                            style: const TextStyle(
                              color: _green, fontSize: 17,
                              fontWeight: FontWeight.w800, fontFamily: 'Manrope',
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _BottomNav(
        selected: 0, langCode: p.langCode, isRTL: isRTL,
        onTap: (i) {
          if (i == 3) Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()));
        },
      ),
    );
  }

  String _welcome(String lang, String name) {
    switch (lang) {
      case 'ar': return 'أهلاً بعودتك، $name';
      case 'es': return 'Bienvenido de nuevo, $name';
      case 'fr': return 'Bon retour, $name';
      case 'de': return 'Willkommen zurück, $name';
      case 'ja': return 'おかえりなさい、$name';
      default:   return 'Welcome back, $name';
    }
  }

  String _homeLabel(String lang) {
    switch (lang) {
      case 'ar': return 'الرئيسية';
      case 'es': return 'Inicio';
      case 'fr': return 'Accueil';
      case 'de': return 'Startseite';
      case 'ja': return 'ホーム';
      default:   return 'Home';
    }
  }

  String _devicesText(String lang) {
    switch (lang) {
      case 'ar': return '$_connectedCount أجهزة ';
      case 'es': return '$_connectedCount dispositivos ';
      case 'fr': return '$_connectedCount appareils ';
      case 'de': return '$_connectedCount Geräte ';
      case 'ja': return '$_connectedCount台のデバイスが';
      default:   return '$_connectedCount devices ';
    }
  }

  String _connectedWord(String lang) {
    switch (lang) {
      case 'ar': return 'متصلة';
      case 'es': return 'conectados';
      case 'fr': return 'connectés';
      case 'de': return 'verbunden';
      case 'ja': return '接続済み';
      default:   return 'Connected';
    }
  }
}


class _WaveAnimIcon extends StatefulWidget {
  final Color color;
  const _WaveAnimIcon({required this.color});
  @override
  State<_WaveAnimIcon> createState() => _WaveAnimIconState();
}

class _WaveAnimIconState extends State<_WaveAnimIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => SizedBox(width: 28, height: 28,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (i) {
          final h = 4.0 + 18.0 * math.sin(((_ctrl.value + i * 0.2) % 1.0) * math.pi);
          return Container(width: 3, height: h.clamp(4.0, 22.0),
              decoration: BoxDecoration(color: widget.color,
                  borderRadius: BorderRadius.circular(2)));
        }),
      ),
    ),
  );
}

class _SmartGlassesIcon extends StatelessWidget {
  const _SmartGlassesIcon();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GlassesPainter(), size: const Size(46, 46));
}
class _GlassesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final st = Paint()..color = _orange..strokeWidth = 2.4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fi = Paint()..color = _orange.withOpacity(0.2)..style = PaintingStyle.fill;
    final cy = s.height * 0.52; final lr = s.width * 0.175;
    final lx = s.width * 0.34; final rx = s.width * 0.66;
    canvas.drawCircle(Offset(lx, cy), lr, fi); canvas.drawCircle(Offset(rx, cy), lr, fi);
    canvas.drawCircle(Offset(lx, cy), lr, st); canvas.drawCircle(Offset(rx, cy), lr, st);
    canvas.drawLine(Offset(lx + lr, cy), Offset(rx - lr, cy), st);
    canvas.drawLine(Offset(lx - lr, cy), Offset(s.width * 0.06, cy), st);
    canvas.drawLine(Offset(rx + lr, cy), Offset(s.width * 0.94, cy), st);
  }
  @override bool shouldRepaint(_) => false;
}

class _SmartCaneIcon extends StatelessWidget {
  const _SmartCaneIcon();
  @override Widget build(BuildContext context) =>
      CustomPaint(painter: _CanePainter(), size: const Size(44, 44));
}
class _CanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final st = Paint()..color = _orange..strokeWidth = 2.2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(s.width*.50,s.height*.10),Offset(s.width*.50,s.height*.84),st);
    canvas.drawLine(Offset(s.width*.50,s.height*.84),Offset(s.width*.64,s.height*.95),st);
    canvas.drawPath(Path()
      ..moveTo(s.width*.50,s.height*.10)
      ..quadraticBezierTo(s.width*.50,s.height*.02,s.width*.61,s.height*.05)
      ..quadraticBezierTo(s.width*.72,s.height*.08,s.width*.69,s.height*.16), st);
    canvas.drawCircle(Offset(s.width*.50,s.height*.46),3.2,Paint()..color=_orange..style=PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}

class _LumoBandIcon extends StatelessWidget {
  const _LumoBandIcon();
  @override Widget build(BuildContext context) => Transform.rotate(angle: -math.pi/2,
      child: CustomPaint(painter: _LumoBandPainter(), size: const Size(44,44)));
}
class _LumoBandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final st = Paint()..color=_orange..strokeWidth=1.9..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    final cx=s.width/2; final cy=s.height/2; final r=s.width*0.28; final sw=r*0.58;
    canvas.drawCircle(Offset(cx,cy),r,st);
    for (final dy in [-1.0, 1.0]) {
      final ey = dy<0 ? cy-r : cy+r; final oy = ey + dy*s.height*.16;
      canvas.drawLine(Offset(cx-sw,ey),Offset(cx-sw,oy),st);
      canvas.drawLine(Offset(cx+sw,ey),Offset(cx+sw,oy),st);
      canvas.drawLine(Offset(cx-sw,oy),Offset(cx+sw,oy),st);
    }
    canvas.drawLine(Offset(cx,cy),Offset(cx,cy-r*.55),st..strokeWidth=2.0);
    canvas.drawLine(Offset(cx,cy),Offset(cx+r*.40,cy),st..strokeWidth=1.6);
    canvas.drawCircle(Offset(cx,cy),2.2,Paint()..color=_orange..style=PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}

class _EarbudsIcon extends StatelessWidget {
  const _EarbudsIcon();
  @override Widget build(BuildContext context) =>
      CustomPaint(painter: _EarbudsPainter(), size: const Size(44,44));
}
class _EarbudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final st = Paint()..color=_orange..strokeWidth=1.9..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    final fi = Paint()..color=_orange..style=PaintingStyle.fill;
    _bud(canvas,s,s.width*.27,st,fi); _bud(canvas,s,s.width*.73,st,fi);
  }
  void _bud(Canvas c,Size s,double cx,Paint st,Paint fi){
    final bw=s.width*.19; final bh=s.height*.33; final cy=s.height*.37;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center:Offset(cx,cy),width:bw,height:bh),Radius.circular(bw*.55)),st);
    c.drawCircle(Offset(cx,cy-bh*.10),bw*.22,st..strokeWidth=1.2);
    c.drawLine(Offset(cx,cy+bh*.48),Offset(cx,cy+bh*.88),st..strokeWidth=1.9);
    c.drawCircle(Offset(cx,cy+bh*.88+s.width*.048),s.width*.052,fi);
  }
  @override bool shouldRepaint(_) => false;
}

class _BottomNav extends StatelessWidget {
  final int selected;
  final String langCode;
  final bool isRTL;
  final Function(int) onTap;

  const _BottomNav({
    required this.selected, required this.langCode,
    required this.isRTL,    required this.onTap,
  });

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
                _item(0, Icons.home_outlined,     Icons.home,     selected==0),
                _item(1, Icons.add_circle_outline, Icons.add_circle, selected==1),
                _item(2, Icons.person_outline,    Icons.person,   selected==2),
                _item(3, Icons.settings_outlined, Icons.settings, selected==3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData icon, IconData active, bool sel) =>
      GestureDetector(
        onTap: () => onTap(i),
        child: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFF27F0D).withOpacity(0.15) : Colors.transparent,
            shape: BoxShape.circle,
            border: sel ? Border.all(color: const Color(0xFFF27F0D).withOpacity(0.4), width: 1.2) : null,
          ),
          child: Icon(sel ? active : icon,
              color: sel ? const Color(0xFFF27F0D) : Colors.white.withOpacity(0.45), size: 26),
        ),
      );
}