import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sptimer/data/enums/timer_status.dart';
import 'package:sptimer/logic/pomodoro_timer/pomodoro_timer_cubit.dart';

import 'package:sptimer/screens/pomodoro_timer/widgets/countdown_timer/controller/circular_rotational_lines_controller.dart';
import 'package:sptimer/screens/pomodoro_timer/widgets/countdown_timer/controller/timer_animations_controller.dart';
import 'package:sptimer/screens/pomodoro_timer/widgets/countdown_timer/widgets/circular_line.dart';
import 'package:sptimer/screens/pomodoro_timer/widgets/countdown_timer/widgets/circular_rotational_lines.dart';
import 'package:sptimer/utils/extensions/extensions.dart';
import 'controller/countdown_timer_controller.dart';
import 'constants.dart';
import 'custom_painters/circular_line_painter.dart';
import 'custom_painters/clock_lines_painter.dart';
import 'custom_painters/circular_background_line_painter.dart';
import 'custom_painters/circular_rotational_lines_painter.dart';
import '../animated_text_style.dart';
import 'widgets/countdown_timer_text.dart';

class CountdownTimer extends StatelessWidget {
  CountdownTimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double radius = 90.r;
    final double strokeWidth = 25.r;
    final double areaSize = radius * 2 + strokeWidth;
    final Size customPaintSize = Size.square(areaSize);
    final theme = context.theme;

    return SizedBox(
      width: areaSize,
      height: areaSize,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularBackgroundLine(
            diameter: radius,
            strokeWidth: strokeWidth,
          ),
          ClockLines(diameter: radius),
          CircularLine(
            diameter: radius,
            strokeWidth: strokeWidth,
          ),
          CircularRotationalLines(
            diameter: radius,
          ),
          TimerCountdownCircle(
            areaSize: areaSize,
            diameter: radius,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class TimerCountdownCircle extends StatelessWidget {
  const TimerCountdownCircle({
    super.key,
    required this.diameter,
  });

  final double diameter;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RepaintBoundary(
      child: Container(
        alignment: AlignmentDirectional.center,
        width: diameter,
        height: diameter,
        child: CircleAvatar(
          radius: diameter,
          backgroundColor: theme.colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: GetBuilder<TimerAnimationsController>(
                  id: kCountdownText_getbuilder,
                  builder: (controller) {
                    return CountdownTimerText(
                      remainingDuration: controller.remainingDuration,
                      animateBack: controller.animateBack,
                    );
                  },
                ),
              ),
              GetBuilder<CountdownTimerController>(
                id: kSubtitleText_getbuilder,
                builder: (controller) {
                  return AnimatedTextStyle(
                    text: controller.subtitleText,
                    textStyle: const TextStyle(fontSize: 0, inherit: false),
                    secondTextStyle: theme.primaryTextTheme.bodyMedium!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockLines extends StatelessWidget {
  const ClockLines({
    super.key,
    required this.diameter,
  });

  final double diameter;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RepaintBoundary(
      child: BlocSelector<PomodoroTimerCubit, PomodoroTimerState, TimerStatus>(
        selector: (state) => state.timerStatus,
        builder: (context, timerStatus) => CustomPaint(
          size: Size.square(diameter),
          painter: ClockLinesPainter(
            hide: !timerStatus.isFinished,
            colors: [
              theme.primaryColorLight,
              theme.primaryColor,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
      ),
    );
  }
}

class CircularBackgroundLine extends StatelessWidget {
  const CircularBackgroundLine({
    super.key,
    required this.diameter,
    required this.strokeWidth,
  });

  final double diameter;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(diameter),
        painter: CircularBackgroundLinePainter(
          strokeWidth: strokeWidth,
          backgroundColor: theme.primaryColorLight.withOpacity(0.1),
          shadowColor: theme.primaryColorDark.withOpacity(0.5),
        ),
      ),
    );
  }
}
