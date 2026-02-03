import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/date_utils.dart';
import 'package:just_audio/just_audio.dart';

final currentValentineDayProvider = Provider<int?>((ref) {
  final now = DateTime.now();
  return valentineDayForDate(now);
});

final audioPlayerProvider = Provider.autoDispose<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});

/// Plays background audio for a given asset path with looping and reduced volume.
Future<void> playBackgroundAudio(AudioPlayer player, String assetPath) async {
  try {
    await player.setAsset(assetPath);
    player.setLoopMode(LoopMode.one);
    player.setVolume(0.3); // reduced volume for background
    player.play();
  } catch (e) {
    // silently ignore if asset missing (e.g., in dev)
  }
}
