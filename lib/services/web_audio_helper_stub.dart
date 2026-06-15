import 'web_audio_helper.dart';

WebAudioHelper getHelper() => throw UnsupportedError('Cannot create a WebAudioHelper without dart:html');

class WebAudioHelperStub implements WebAudioHelper {
	@override
	Future<void> playAudio(String base64Audio) async {}

	@override
	void stop() {}
}
