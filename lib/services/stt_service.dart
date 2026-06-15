import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class STTService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;
  bool _listening = false;
  bool _shouldKeepListening = false;
  Function(String text, bool isFinal)? _currentOnResult;
  String _currentLocaleId = 'en_US';
  Timer? _restartTimer;

  Future<void> initialize() async {
    try {
      _available = await _speech.initialize(
        onError: (errorNotification) {
          print('[STTService] Error: ${errorNotification.errorMsg} - ${errorNotification.permanent}');
          if (_shouldKeepListening) {
            _scheduleRestart('error: ${errorNotification.errorMsg}');
          }
        },
        onStatus: (status) {
          print('[STTService] Status: $status');
          if (_shouldKeepListening && (status == 'done' || status == 'notListening')) {
            _scheduleRestart('status: $status');
          }
        },
      );
      print('[STTService] Available: $_available');
    } catch (e) {
      print('[STTService] Initialization exception: $e');
      _available = false;
    }
  }

  void _scheduleRestart(String reason) {
    _restartTimer?.cancel();
    _restartTimer = Timer(const Duration(milliseconds: 700), () async {
      if (_shouldKeepListening && !_speech.isListening) {
        print('[STTService] Auto-restarting session due to $reason');
        await _startListeningSession();
      }
    });
  }

  bool get isAvailable => _available;
  bool get isListening => _listening;

  Future<void> listen(Function(String text, bool isFinal) onResult, {String localeId = 'en_US'}) async {
    if (!_available) await initialize();
    if (!_available) return;

    _shouldKeepListening = true;
    _currentOnResult = onResult;
    _currentLocaleId = localeId;
    _listening = true;

    await _startListeningSession();
  }

  Future<void> _startListeningSession() async {
    if (!_available || _speech.isListening) return;

    try {
      await _speech.listen(
        onResult: (result) {
          if (_currentOnResult != null) {
            _currentOnResult!(result.recognizedWords, result.finalResult);
          }
        },
        localeId: _currentLocaleId,
        listenMode: stt.ListenMode.dictation,
        pauseFor: const Duration(seconds: 60),
        listenFor: const Duration(seconds: 60),
        cancelOnError: false,
        partialResults: true,
      );
    } catch (e) {
      print('[STTService] Error starting listen session: $e');
      if (_shouldKeepListening) {
        _scheduleRestart('exception: $e');
      }
    }
  }

  Future<void> stop() async {
    _shouldKeepListening = false;
    _listening = false;
    _restartTimer?.cancel();
    _currentOnResult = null;
    await _speech.stop();
  }

  Future<void> cancel() async {
    _shouldKeepListening = false;
    _listening = false;
    _restartTimer?.cancel();
    _currentOnResult = null;
    await _speech.cancel();
  }
}
