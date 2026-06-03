import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class BraceletsListScreen extends StatefulWidget {
  const BraceletsListScreen({super.key});

  @override
  State<BraceletsListScreen> createState() => _BraceletsListScreenState();
}

class _BraceletsListScreenState extends State<BraceletsListScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final Map<String, Map<String, String>> _translations = {
    'en': {
      'title': 'Bracelets',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'devices': 'devices',
      'lh': 'Left Hand', 'rh': 'Right Hand', 'll': 'Left Leg', 'rl': 'Right Leg',
      'pos_tl': 'Top left, Left Hand Sensor',
      'pos_tr': 'Top right, Right Hand Sensor',
      'pos_bl': 'Bottom left, Left Leg Sensor',
      'pos_br': 'Bottom right, Right Leg Sensor',
    },
    'ar': {
      'title': 'الأساور',
      'connected': 'متصل',
      'disconnected': 'غير متصل',
      'devices': 'أجهزة',
      'lh': 'اليد اليسرى', 'rh': 'اليد اليمنى', 'll': 'القدم اليسرى', 'rl': 'القدم اليمنى',
      'pos_tl': 'أعلى اليسار، حساس اليد اليسرى',
      'pos_tr': 'أعلى اليمين، حساس اليد اليمنى',
      'pos_bl': 'أسفل اليسار، حساس القدم اليسرى',
      'pos_br': 'أسفل اليمين، حساس القدم اليمنى',
    },
    'es': {
      'title': 'Pulseras',
      'connected': 'Conectado',
      'disconnected': 'Desconectado',
      'devices': 'dispositivos',
      'lh': 'Mano Izquierda', 'rh': 'Mano Derecha', 'll': 'Pierna Izquierda', 'rl': 'Pierna Derecha',
      'pos_tl': 'Arriba a la izquierda, sensor de la mano izquierda',
      'pos_tr': 'Arriba a la derecha, sensor de la mano derecha',
      'pos_bl': 'Abajo a la izquierda, sensor de la pierna izquierda',
      'pos_br': 'Abajo a la derecha, sensor de la pierna derecha',
    },
    'fr': {
      'title': 'Bracelets',
      'connected': 'Connecté',
      'disconnected': 'Déconnecté',
      'devices': 'appareils',
      'lh': 'Main Gauche', 'rh': 'Main Droite', 'll': 'Jambe Gauche', 'rl': 'Jambe Droite',
      'pos_tl': 'En haut à gauche, capteur main gauche',
      'pos_tr': 'En haut à droite, capteur main droite',
      'pos_bl': 'En bas à gauche, capteur jambe gauche',
      'pos_br': 'En bas à droite, capteur jambe droite',
    },
    'de': {
      'title': 'Armbänder',
      'connected': 'Verbunden',
      'disconnected': 'Getrennt',
      'devices': 'Geräte',
      'lh': 'Linke Hand', 'rh': 'Rechte Hand', 'll': 'Linkes Bein', 'rl': 'Rechtes Bein',
      'pos_tl': 'Oben links, Linker Handsensor',
      'pos_tr': 'Oben rechts, Rechter Handsensor',
      'pos_bl': 'Unten links, Linker Beinsensor',
      'pos_br': 'Unten rechts, Rechter Beinsensor',
    },
    'ja': {
      'title': 'ブレスレット',
      'connected': '接続済み',
      'disconnected': '未接続',
      'devices': 'デバイス',
      'lh': '左手', 'rh': '右手', 'll': '左足', 'rl': '右足',
      'pos_tl': '左上、左手センサー',
      'pos_tr': '右上、右手センサー',
      'pos_bl': '左下、左足センサー',
      'pos_br': '右下、右足センサー',
    },
  };
  final List<Map<String, dynamic>> _sensors = [
    {'key': 'lh', 'pos': 'pos_tl', 'connected': true},
    {'key': 'rh', 'pos': 'pos_tr', 'connected': true},
    {'key': 'll', 'pos': 'pos_bl', 'connected': false},
    {'key': 'rl', 'pos': 'pos_br', 'connected': true},
  ];

  @override
  void initState() {
    super.initState();
    _setupTts();
  }

  Future<void> _setupTts() async {
    final provider = context.read<LocaleProvider>();
    await flutterTts.setLanguage(provider.langCode);
  }

  String _t(String key, String langCode) =>
      _translations[langCode]?[key] ?? _translations['en']![key]!;

  void _handleTap(int index, String langCode) async {
    setState(() {
      _sensors[index]['connected'] = !_sensors[index]['connected'];
    });
    String status = _sensors[index]['connected'] ? _t('connected', langCode) : _t('disconnected', langCode);
    String speechText = "${_t(_sensors[index]['pos'], langCode)}, $status";
    await flutterTts.setLanguage(langCode);
    await flutterTts.speak(speechText);
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final String currentLang = localeProvider.langCode;
    final bool isRtl = localeProvider.isRTL;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bracelets_list_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(isRtl, currentLang),
                const SizedBox(height: 110),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _sensorItem(0, currentLang)),
                            const SizedBox(width: 20),
                            Expanded(child: _sensorItem(1, currentLang)),
                          ],
                        ),
                        const SizedBox(height: 108),
                        Row(
                          children: [
                            Expanded(child: _sensorItem(2, currentLang)),
                            const SizedBox(width: 20),
                            Expanded(child: _sensorItem(3, currentLang)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sensorItem(int index, String lang) {
    bool isConnected = _sensors[index]['connected'];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(index, lang),
      onDoubleTap: () {
        debugPrint("Double tap detected on sensor $index");
        Navigator.of(context).pop();
      },
      child: Container(
        height: 150,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              _t(_sensors[index]['key'], lang),
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isConnected ? _t('connected', lang) : _t('disconnected', lang),
              style: GoogleFonts.manrope(
                color: isConnected ? const Color(0xFFFF6A00) : Colors.white24,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(bool isRtl, String lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
      child: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              _t('title', lang),
              style: GoogleFonts.manrope(
                color: const Color(0xFFFF6A00),
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: isRtl
                  ? [
                Text(_t('connected', lang), style: const TextStyle(color: Color(0xFF2FE344), fontWeight: FontWeight.bold)),
                Text(' ${_t('devices', lang)} ${_sensors.where((s) => s['connected']).length}', style: const TextStyle(color: Colors.white60, fontSize: 15)),
              ]
                  : [
                Text('${_sensors.where((s) => s['connected']).length} ${_t('devices', lang)} ', style: const TextStyle(color: Colors.white60, fontSize: 15)),
                Text(_t('connected', lang), style: const TextStyle(color: Color(0xFF2FE344), fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}