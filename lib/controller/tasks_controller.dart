import 'package:get/get.dart';
import 'package:pomotimer/data/database/tasks_database.dart';
import 'package:pomotimer/data/models/pomodoro_model.dart';

class TasksController extends GetxController {
  final RxList tasks = [].obs;
  final TasksDatabase _database = TasksDatabase();

  @override
  void onInit() async {
    await _database.init();
    final result = await _database.getAll();
    result.fold(
      (l) => print(l),
      (r) => tasks.value = r,
    );
    super.onInit();
  }

  Future<void> addTask(PomodoroTaskModel task) async {
    final result = await _database.add(task);
    result.fold(
      (l) => print(l),
      (r) {
        task.id = r;
        tasks.add(task);
      },
    );
  }

  Future<void> updateTask(PomodoroTaskModel task) async {
    final result = await _database.update(task);
    result.fold(
      (l) => print(l),
      (r) {
        final index = tasks.indexWhere((e) => e.id == task.id);
        tasks[index] = task;
      },
    );
  }

  Future<void> deleteTask(int id) async {
    final result = await _database.delete(id);
    result.fold(
      (l) => print(l),
      (r) {
        final index = tasks.indexWhere((e) => e.id == id);
        tasks.removeAt(index);
      },
    );
  }
}