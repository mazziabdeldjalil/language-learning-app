import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'web_audio_helper.dart';

class GcpTtsService {
  static const String _apiKey = 'AIzaSyDtGYzbKt5xjvYCJtiPSyOaONZN4HIkj_Y';
  static const String _endpoint =
      'https://texttospeech.googleapis.com/v1/text:synthesize';

  // For mobile (Android/iOS)
  final FlutterTts _flutterTts = FlutterTts();

  // Web audio helper — interface is safe for all platforms
  final WebAudioHelper? _webAudioHelper = kIsWeb ? WebAudioHelper() : null;

  Map<String, dynamic> _emotionConfig(String emotion) {
    switch (emotion) {
      case 'enthusiastic':
        return {'speakingRate': 1.15, 'pitch': 2.0};
      case 'encouraging':
        return {'speakingRate': 1.0, 'pitch': 1.5};
      case 'professional':
        return {'speakingRate': 0.95, 'pitch': 0.0};
      case 'friendly':
        return {'speakingRate': 1.05, 'pitch': 1.0};
      case 'helpful':
        return {'speakingRate': 1.0, 'pitch': 0.5};
      case 'calm':
        return {'speakingRate': 0.9, 'pitch': -1.0};
      default:
        return {'speakingRate': 1.0, 'pitch': 0.0};
    }
  }

  String _voiceForScenario(String scenario) {
    switch (scenario) {
      case 'casual':
        return 'en-US-Neural2-A';
      case 'interview':
        return 'en-US-Neural2-F';
      case 'travel':
        return 'en-US-Journey-F';
      default:
        return 'en-US-Journey-F';
    }
  }

  bool _supportsPitch(String voiceName) {
    return !voiceName.contains('Journey');
  }

  Future<void> speak(
    String text, {
    String emotion = 'neutral',
    String scenario = 'casual',
  }) async {
    try {
      await stop();

      if (kIsWeb) {
        // Web: use GCP TTS + HTML audio
        await _speakWeb(text, emotion: emotion, scenario: scenario);
      } else {
        // Mobile: use flutter_tts
        await _speakMobile(text, emotion: emotion);
      }
    } catch (e) {
      print('[GcpTtsService] Exception: $e');
    }
  }

  Future<void> _speakMobile(String text, {String emotion = 'neutral'}) async {
    final config = _emotionConfig(emotion);
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(
        ((config['speakingRate'] as double) * 0.5).clamp(0.0, 1.0));
    await _flutterTts.setPitch(
        ((config['pitch'] as double) / 10 + 1.0).clamp(0.5, 2.0));
    await _flutterTts.speak(text);
  }

  Future<void> _speakWeb(
    String text, {
    String emotion = 'neutral',
    String scenario = 'casual',
  }) async {
    final config = _emotionConfig(emotion);
    final voiceName = _voiceForScenario(scenario);

    final Map<String, dynamic> audioConfig = {
      "audioEncoding": "MP3",
      "speakingRate": config['speakingRate'],
    };

    if (_supportsPitch(voiceName)) {
      audioConfig["pitch"] = config['pitch'];
    }

    final response = await http.post(
      Uri.parse('$_endpoint?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "input": {"text": text},
        "voice": {
          "languageCode": "en-US",
          "name": voiceName,
        },
        "audioConfig": audioConfig,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String audioContent = data['audioContent'];
      await _webAudioHelper?.playAudio(audioContent);
    } else {
      print('[GcpTtsService] Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> stop() async {
    if (kIsWeb) {
      _webAudioHelper?.stop();
    } else {
      await _flutterTts.stop();
    }
  }

  void dispose() {
    stop();
  }
}