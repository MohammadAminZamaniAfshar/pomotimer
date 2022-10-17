import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pomotimer/controller/main_controller.dart';
import 'package:pomotimer/data/models/pomodoro_task_model.dart';
import 'package:pomotimer/ui/screens/start_pomodoro_task_screen/start_pomodoro_task_screen_controller.dart';
import 'package:pomotimer/ui/screens/start_pomodoro_task_screen/widgets/back_alert_dialog.dart';
import 'package:pomotimer/ui/screens/start_pomodoro_task_screen/widgets/gradient_text.dart';
import 'package:pomotimer/ui/screens/start_pomodoro_task_screen/widgets/pomodoro_finish_snackbar.dart';
import 'package:pomotimer/util/util.dart';
import 'start_pomodoro_task_screen_controller.dart';
import 'widgets/circle_animated_button/circle_animated_button.dart';
import 'widgets/countdown_timer/countdown_timer.dart';

class StartPomodoroTaskScreen extends StatefulWidget {
  const StartPomodoroTaskScreen({Key? key, this.task}) : super(key: key);
  final PomodoroTaskModel? task;

  @override
  State<StartPomodoroTaskScreen> createState() => _StartPomodoroTaskScreenState();
}

class _StartPomodoroTaskScreenState extends State<StartPomodoroTaskScreen> {
  @override
  void initState() {
    if (widget.task != null) {
      final controller = Get.put(StartPomodoroTaskScreenController());
      controller.init(widget.task!);
    }
    Get.find<StartPomodoroTaskScreenController>().snackbarNotifier.listen((_) {
      Future.delayed(
        const Duration(milliseconds: 700),
        () {
          if (mounted) showPomodoroFinishSnackBar(context, kPomodoroFinishText);
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<StartPomodoroTaskScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StartPomodoroTaskScreenController>();
    return WillPopScope(
      onWillPop: () async {
        if (controller.isTimerStarted) {
          await Get.find<MainController>().onAppPaused();
          SystemNavigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 20.h),
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  controller.showLinerGradientColors
                      ? const Color(0xFFBFDDE2)
                      : const Color(0xFFEBE8E8),
                  const Color(0xFFECECEC),
                ],
                stops: const [
                  0.1,
                  0.55,
                ],
              ),
            ),
            child: const _Body(),
          );
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartPomodoroTaskScreenController controller = Get.find();
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _AppBar(),
          SizedBox(height: 5.h),
          const CountdownTimer(),
          const SizedBox(),
          Container(
            alignment: Alignment.center,
            height: 50.h,
            child: Obx(
              () => GradientText(
                colors: [
                  theme.primaryColorLight,
                  theme.primaryColorDark,
                ],
                text: AnimatedTextStyle(
                  text: controller.pomodoroText,
                  textStyle: const TextStyle(fontSize: 0, inherit: false),
                  secondTextStyle: theme.primaryTextTheme.bodyLarge!,
                ),
              ),
            ),
          ),
          CircleAnimatedButton(
            onStart: controller.start,
            onPause: controller.pause,
            onResume: controller.resume,
            onFinish: () {
              controller.cancel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartPomodoroTaskScreenController controller = Get.find();
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BackButton(
          onPressed: () {
            if (!controller.isTimerStarted) return Navigator.pop(context);
            showBackAlertDialog(
              context,
              onContinue: () {
                Navigator.pop(context);
              },
              onCancel: () {
                controller.cancel();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          },
        ),
        const Spacer(),
        Text(
          controller.pomodoroTask.title,
          style: theme.textTheme.headlineSmall,
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
