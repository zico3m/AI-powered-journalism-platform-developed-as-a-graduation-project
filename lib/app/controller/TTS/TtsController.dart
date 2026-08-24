// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import '../../models/data/services/tts/tts_service.dart';
// import 'package:audio_session/audio_session.dart';
//
// class NewsTtsController extends GetxController {
//   final TtsService _ttsService = TtsService();
//   final AudioPlayer _player = AudioPlayer();
//
//   final RxBool isLoading = false.obs;
//   final RxBool isPlaying = false.obs;
//
//   Future<void> play(String text) async {
//     try {
//       isLoading.value = true;
//
//       // 🔴 هذا هو السطر الحاسم
//       final session = await AudioSession.instance;
//       await session.configure(
//         const AudioSessionConfiguration.speech(),
//       );
//
//       final File audioFile = await _ttsService.generateSpeech(text);
//       print("AUDIO PATH: ${audioFile.path}");
//       print("SIZE: ${audioFile.lengthSync()}");
//       await _player.setAudioSource(
//         AudioSource.uri(Uri.file(audioFile.path)),
//       );
//
//       await _player.play();
//       isPlaying.value = true;
//
//       _player.playerStateStream.listen((state) {
//         if (state.processingState == ProcessingState.completed) {
//           isPlaying.value = false;
//         }
//       });
//     } catch (e) {
//       Get.snackbar("خطأ", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   Future<void> stop() async {
//     await _player.stop();
//     isPlaying.value = false;
//   }
//
//   @override
//   void onClose() {
//     _player.dispose();
//     super.onClose();
//   }
// }


import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../models/data/services/tts/tts_service.dart';

class NewsTtsController extends GetxController {
  final TtsService _ttsService = TtsService();
  final AudioPlayer _player = AudioPlayer();

  final RxBool isLoading = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString selectedVoice = "noura".obs;

  Future<void> play(String text) async {
    try {
      isLoading.value = true;

      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration.speech(),
      );

      final File audioFile =
      await _ttsService.generateSpeech(text, selectedVoice.value);

      await _player.setAudioSource(
        AudioSource.uri(Uri.file(audioFile.path)),
      );

      await _player.play();
      isPlaying.value = true;

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaying.value = false;
        }
      });
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
