// lib/services/voice_service.dart
//
// ════════════════════════════════════════════════════════════
//  SINGLE-FILE VOICE SERVICE
//
//  Android / iOS  → flutter_tts + speech_to_text  (real)
//  Windows / Web  → silent no-op  (no nuget, no crash)
//
//  pubspec.yaml:
//    flutter_tts: ^4.0.2
//    speech_to_text: ^7.0.0
// ════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceService {
  // ── Singleton ─────────────────────────────────────────
  VoiceService._();
  static final VoiceService _i = VoiceService._();
  factory VoiceService() => _i;

  // ── Internal state ────────────────────────────────────
  FlutterTts?       _tts;
  stt.SpeechToText? _stt;
  bool _ttsReady  = false;
  bool _sttReady  = false;
  bool _listening = false;

  bool get isListening => _listening;
  bool get ttsReady    => _ttsReady;
  bool get sttReady    => _sttReady;

  // Only run real TTS/STT on Android & iOS
  bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS;

  // ══════════════════════════════════════════════════════
  //  INIT — call once from main() before runApp
  // ══════════════════════════════════════════════════════
  Future<void> init() async {
    if (!_isMobile) return;
    await _initTts();
    await _initStt();
  }

  Future<void> _initTts() async {
    try {
      _tts = FlutterTts();
      await _tts!.setVolume(1.0);
      await _tts!.setSpeechRate(0.48);
      await _tts!.setPitch(1.0);
      _ttsReady = true;
    } catch (e) {
      debugPrint('[VoiceService] TTS init: $e');
      _tts = null;
    }
  }

  Future<void> _initStt() async {
    try {
      _stt = stt.SpeechToText();
      _sttReady = await _stt!.initialize(
        onError:  (e) => debugPrint('[VoiceService] STT error: $e'),
        onStatus: (s) => debugPrint('[VoiceService] STT status: $s'),
      );
    } catch (e) {
      debugPrint('[VoiceService] STT init: $e');
      _stt = null;
    }
  }

  // ══════════════════════════════════════════════════════
  //  SPEAK
  // ══════════════════════════════════════════════════════
  Future<void> speak(
      String text, {
        String lang   = 'en',
        String gender = 'female',
        double rate   = 0.48,
      }) async {
    // No-op on Windows/Web or if not initialized
    if (!_isMobile || !_ttsReady || _tts == null) return;
    if (text.trim().isEmpty) return;

    try {
      await _tts!.stop();
      await _tts!.setLanguage(_ttsLocale(lang));
      await _tts!.setPitch(gender == 'female' ? 1.15 : 0.82);
      await _tts!.setSpeechRate(rate);

      // Wait for utterance to finish before returning
      final done = Completer<void>();
      _tts!.setCompletionHandler(() { if (!done.isCompleted) done.complete(); });
      _tts!.setCancelHandler(()    { if (!done.isCompleted) done.complete(); });
      _tts!.setErrorHandler((_)   { if (!done.isCompleted) done.complete(); });

      await _tts!.speak(text);

      // Timeout = rough estimate based on word count
      await done.future.timeout(
        Duration(seconds: (text.length ~/ 8) + 6),
        onTimeout: () {},
      );
    } catch (e) {
      debugPrint('[VoiceService] speak: $e');
    }
  }

  Future<void> stop() async {
    try { await _tts?.stop(); } catch (_) {}
  }

  // ══════════════════════════════════════════════════════
  //  LISTEN (STT)
  // ══════════════════════════════════════════════════════
  Future<String> listen({
    String lang  = 'en',
    Duration timeout = const Duration(seconds: 9),
    void Function(String partial)? onPartial,
  }) async {
    if (!_isMobile || !_sttReady || _stt == null || _listening) return '';

    _listening = true;
    String finalText = '';
    final done = Completer<String>();

    try {
      await _stt!.listen(
        localeId:       _sttLocale(lang),
        listenFor:      timeout,
        pauseFor:       const Duration(seconds: 3),
        partialResults: true,
        cancelOnError:  false,
        onResult: (SpeechRecognitionResult r) {
          if (onPartial != null) onPartial(r.recognizedWords);
          if (r.finalResult && !done.isCompleted) {
            finalText = r.recognizedWords;
            done.complete(finalText);
          }
        },
      );

      finalText = await done.future.timeout(
        timeout + const Duration(seconds: 3),
        onTimeout: () => finalText,
      );
    } catch (e) {
      debugPrint('[VoiceService] listen: $e');
    } finally {
      _listening = false;
      try { await _stt?.stop(); } catch (_) {}
    }

    return finalText.trim();
  }

  Future<void> stopListening() async {
    _listening = false;
    try { await _stt?.stop(); } catch (_) {}
  }

  // ══════════════════════════════════════════════════════
  //  LOCALE MAPS
  // ══════════════════════════════════════════════════════
  String _ttsLocale(String lang) => const {
    'en': 'en-US', 'ar': 'ar-SA', 'es': 'es-ES',
    'fr': 'fr-FR', 'de': 'de-DE', 'ja': 'ja-JP',
  }[lang] ?? 'en-US';

  String _sttLocale(String lang) => const {
    'en': 'en_US', 'ar': 'ar_SA', 'es': 'es_ES',
    'fr': 'fr_FR', 'de': 'de_DE', 'ja': 'ja_JP',
  }[lang] ?? 'en_US';
}