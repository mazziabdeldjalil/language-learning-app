import 'dart:html' as html;
import 'dart:async';
import 'web_audio_helper.dart';

WebAudioHelper getHelper() => WebAudioHelperWeb();

class WebAudioHelperWeb implements WebAudioHelper {
  html.AudioElement? _audioElement;
  Completer<void>? _completer;
  bool _stopped = false;

  @override
  Future<void> playAudio(String base64Audio) async {
    stop();
    _stopped = false;
    _completer = Completer<void>();

    final uri = 'data:audio/mp3;base64,$base64Audio';
    _audioElement = html.AudioElement(uri);

    _audioElement!.onEnded.listen((_) {
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
      }
    });

    _audioElement!.onError.listen((_) {
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
      }
    });

    try {
      await _audioElement!.play();
    } catch (e) {
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
      }
      return;
    }

    if (!_stopped) {
      await _completer?.future;
    }
  }

  @override
  void stop() {
    _stopped = true;
    if (!(_completer?.isCompleted ?? true)) {
      _completer?.complete();
    }
    _audioElement?.pause();
    _audioElement?.remove();
    _audioElement = null;
    _completer = null;
  }
}
