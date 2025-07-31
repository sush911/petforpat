import 'package:audioplayers/audioplayers.dart';

class NotificationSoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSound() async {
    try {
      await _player.stop(); // Ensure previous sound is stopped
      await _player.play(AssetSource('sounds/notify.mp3'));
    } catch (e) {
      print("🔊 Error playing notification sound: $e");
    }
  }
}
