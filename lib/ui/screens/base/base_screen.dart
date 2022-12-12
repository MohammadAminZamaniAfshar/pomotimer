import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pomotimer/data/models/pomodoro_task_model.dart';
import 'package:pomotimer/routes/routes_name.dart';
import 'package:pomotimer/ui/screens/base/widgets/custom_bottom_navigation_bar.dart';
import 'package:pomotimer/ui/screens/calendar/calendar_screen.dart';
import 'package:pomotimer/ui/screens/calendar/calendar_screen_controller.dart';
import 'package:pomotimer/ui/screens/tasks/tasks_controller.dart';
import 'package:pomotimer/ui/screens/tasks/tasks_screen.dart';
import 'package:pomotimer/ui/widgets/widgets.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key}) {
    Get.put(TasksController());
    Get.put(CalendarScreenController());
  }

  final screens = const [
    TasksScreen(),
    CalendarScreen(),
  ];

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onChange: (currentIndex) {
          pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleNeumorphicButton(
        radius: 65.r,
        colors: [
          theme.primaryColorLight,
          theme.primaryColorDark,
        ],
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.r,
        ),
        onTap: () async {
          final result = await Navigator.pushNamed(context, RoutesName.addPomodoroTaskScreen);
          if (result == null) return;
          Get.find<TasksController>().addTask(result as PomodoroTaskModel);
        },
      ),
    );
  }
}
