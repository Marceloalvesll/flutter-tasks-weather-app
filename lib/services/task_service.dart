import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> getAllTasks() => _taskBox.values.toList();

  void addTask(Task task) => _taskBox.add(task);

  void updateTask(int index, Task task) => _taskBox.putAt(index, task);

  void deleteTask(int index) => _taskBox.deleteAt(index);
}
