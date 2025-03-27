import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = taskService.getAllTasks();

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Tarefas')),
      body: tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa encontrada'))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(tasks[index].title),
            subtitle:
            Text(DateFormat('dd/MM/yyyy').format(tasks[index].date)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  taskService.deleteTask(index);
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailScreen(task: tasks[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}