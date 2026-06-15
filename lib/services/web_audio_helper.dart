import 'web_audio_helper_stub.dart'
    if (dart.library.html) 'web_audio_helper_web.dart';

abstract class WebAudioHelper {
  factory WebAudioHelper() => getHelper();
  Future<void> playAudio(String base64Audio);
  void stop();
}
