import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService._();
  static final GeminiService _i = GeminiService._();
  factory GeminiService() => _i;
  static const _apiKey = 'YAIzaSyDRTcoUqaiE7AGBcEtsL8FxEJwIS10qSAw';

  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'gemini-2.0-flash:generateContent';

  final List<Map<String, dynamic>> _history = [];
  Future<String> ask({
    required String question,
    required String lang,
    required String userName,
    String gender = 'female',
    bool keepHistory = true,
  }) async {
    if (_apiKey == 'AIzaSyDRTcoUqaiE7AGBcEtsL8FxEJwIS10qSAw') {
      return _noKeyMsg(lang);
    }
    if (question.trim().isEmpty) return '';
    if (keepHistory) {
      _history.add({'role': 'user', 'parts': [{'text': question}]});
      if (_history.length > 20) _history.removeRange(0, 2);
    }

    final contents = keepHistory
        ? List<Map<String, dynamic>>.from(_history)
        : [{'role': 'user', 'parts': [{'text': question}]}];

    try {
      final uri = Uri.parse('$_baseUrl?key=$_apiKey');
      final body = jsonEncode({
        'system_instruction': {
          'parts': [{'text': _systemPrompt(lang, userName)}]
        },
        'contents': contents,
        'generationConfig': {
          'maxOutputTokens': 280,
          'temperature':     0.70,
          'topP':            0.95,
        },
        'safetySettings': [
          {'category': 'HARM_CATEGORY_HARASSMENT',        'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_HATE_SPEECH',       'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_NONE'},
        ],
      });

      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 14));

      if (response.statusCode == 200) {
        final data  = jsonDecode(response.body);
        final text  = (data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '').toString().trim();
        if (keepHistory && text.isNotEmpty) {
          _history.add({'role': 'model', 'parts': [{'text': text}]});
        }
        return text;
      } else {
        debugPrint('[Gemini] HTTP ${response.statusCode}: ${response.body}');
        return _errorMsg(lang);
      }
    } on Exception catch (e) {
      debugPrint('[Gemini] error: $e');
      return _errorMsg(lang);
    }
  }
  void clearHistory() => _history.clear();
  static String _systemPrompt(String lang, String userName) => '''
You are Lumos — a friendly, concise AI voice assistant embedded in the Lumos accessibility app.
The app helps visually impaired users control 4 smart devices:
  1. Smart Glasses   — for visual assistance and object detection
  2. Smart Cane      — navigation and obstacle detection
  3. Lumo Band       — biometric bracelet sensors
  4. Earbuds         — audio feedback and hearing support

The user's name is "$userName".
Always respond in the language with ISO code "$lang" (Arabic if "ar", English if "en", etc.).
Keep every answer to 2–3 short sentences maximum — it will be read aloud by TTS.
Be warm, helpful, and accessibility-focused.
Never mention that you are Gemini or made by Google. You are Lumos.
If the user asks to navigate to a device, suggest they say the device name while holding the screen.
''';

  static String _noKeyMsg(String lang) {
    const msgs = {
      'ar': 'مفتاح Gemini API غير مضبوط. أضفه في ملف gemini_service.dart.',
      'en': 'Gemini API key not set. Please add it to gemini_service.dart.',
      'es': 'Clave API de Gemini no configurada.',
      'fr': 'Clé API Gemini non configurée.',
      'de': 'Gemini API-Schlüssel nicht gesetzt.',
      'ja': 'Gemini APIキーが設定されていません。',
    };
    return msgs[lang] ?? msgs['en']!;
  }

  static String _errorMsg(String lang) {
    const msgs = {
      'ar': 'عذراً، حدث خطأ. تحقق من اتصالك بالإنترنت.',
      'en': 'Sorry, something went wrong. Check your internet connection.',
      'es': 'Lo siento, algo salió mal.',
      'fr': 'Désolé, une erreur est survenue.',
      'de': 'Entschuldigung, ein Fehler ist aufgetreten.',
      'ja': '申し訳ありません、エラーが発生しました。',
    };
    return msgs[lang] ?? msgs['en']!;
  }
}