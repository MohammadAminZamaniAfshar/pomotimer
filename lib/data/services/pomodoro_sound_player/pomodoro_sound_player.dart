import 'package:just_audio/just_audio.dart';
import 'package:pomotimer/data/enum/pomodoro_status.dart';
import 'package:pomotimer/data/enum/tones.dart';
import 'package:pomotimer/data/models/pomodoro_task_model.dart';
import 'package:pomotimer/util/util.dart';
import 'package:real_volume/real_volume.dart';
import 'package:vibration/vibration.dart';
import 'package:audio_session/audio_session.dart';

const _ringtoneAudioConfig = AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategory.playback,
  avAudioSessionMode: AVAudioSessionMode.defaultMode,
  androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  androidAudioAttributes: AndroidAudioAttributes(
    contentType: AndroidAudioContentType.speech,
    flags: AndroidAudioFlags.none,
    usage: AndroidAudioUsage.notificationRingtone,
  ),
);

class PomodoroSoundPlayer {
  late AudioPlayer _tonePlayer;
  late AudioPlayer _statusPlayer;
  late PomodoroTaskModel? _task;

  Future<void> init([PomodoroTaskModel? task]) async {
    _task = task;
    _statusPlayer = AudioPlayer();
    _tonePlayer = AudioPlayer();
    (await AudioSession.instance).configure(_ringtoneAudioConfig);
  }

  Future<bool> isSoundPlayerMuted() async {
    if (await canVibrate() && _task!.vibrate) return false;
    return (_task!.tone == Tones.none && _task!.readStatusAloud == false) ||
        await isRingerMuted() ||
        (_task?.statusVolume == 0.0 && _task!.toneVolume == 0.0);
  }

  Future<bool> isRingerMuted() async {
    return await RealVolume.getRingerMode() != RingerMode.NORMAL;
  }

  Future<bool> canVibrate() async {
    return (await RealVolume.getRingerMode() != RingerMode.SILENT) &&
        ((await Vibration.hasVibrator()) ?? false);
  }

  Future<void> vibrate() async {
    if (await canVibrate()) {
      await Vibration.vibrate(pattern: kVibrationPattern);
    }
  }

  Future<void> setVolume(double volume) async {
    if (await isRingerMuted()) return;
    await RealVolume.setVolume(volume, showUI: false, streamType: StreamType.RING);
  }

  Future<void> playTone(Tones tone) async {
    final path = '$kTonesBasePath${tone.name}.${tone.type}';
    await _tonePlayer.setAsset(path);
    await _tonePlayer.play();
  }

  Future<void> playPomodoroSound(PomodoroStatus status) async {
    if (await isRingerMuted()) return;
    if (_task!.vibrate) {
      vibrate();
    }
    if (_task!.tone != Tones.none && _task!.toneVolume != 0.0) {
      await setVolume(_task!.toneVolume);
      playTone(_task!.tone);
    }
    if (_task!.readStatusAloud && _task!.statusVolume != 0.0) {
      await Future.delayed(const Duration(seconds: 1));
      await setVolume(_task!.toneVolume);
      await readStatusAloud(status: status);
    }
  }

  Future<void> readStatusAloud({
    required PomodoroStatus status,
  }) async {
    if (status.isWorkTime) {
      await _statusPlayer.setAsset(kWorkTimeSoundPath);
    } else if (status.isShortBreakTime) {
      await _statusPlayer.setAsset(kShortBreakTimeSoundPath);
    } else {
      await _statusPlayer.setAsset(kLongBreakSoundPath);
    }
    await _statusPlayer.play();
  }

  Future<void> dispose() async {
    await _statusPlayer.dispose();
    await _tonePlayer.dispose();
  }
}
