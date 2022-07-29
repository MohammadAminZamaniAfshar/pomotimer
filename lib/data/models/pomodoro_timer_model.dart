import 'dart:convert';

import 'package:android_long_task/android_long_task.dart';
import 'package:get/get.dart';

import 'package:pomotimer/util/util.dart';

class PomodoroTimerModel implements ServiceData {
  PomodoroTimerModel({
    required this.maxRound,
    required this.remainingDuration,
    required this.pomodoroRound,
    required this.isWorkTime,
  });
  final Duration remainingDuration;
  final int maxRound;
  final int pomodoroRound;
  final bool isWorkTime;

  Map<String, Object> toMap() => {
        kRemainingDurationKey: remainingDuration.inSeconds,
        kPomodoroRoundKey: pomodoroRound,
        kMaxRoundKey: maxRound,
        kIsWorkTimeKey: isWorkTime,
      };

  static PomodoroTimerModel fromMap(Map<String, dynamic> data) => PomodoroTimerModel(
        remainingDuration: (data[kRemainingDurationKey] as int).seconds,
        pomodoroRound: data[kPomodoroRoundKey] as int,
        maxRound: data[kMaxRoundKey] as int,
        isWorkTime: data[kIsWorkTimeKey] as bool,
      );

  @override
  String get notificationDescription => remainingDuration.toString();

  @override
  String get notificationTitle => 'PomoTimer';

  @override
  String toJson() => jsonEncode(toMap());
}
