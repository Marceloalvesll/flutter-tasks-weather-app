import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TaskService taskService = TaskService();
  final titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void submit() {
    final task = Task(title: titleController.text, date: selectedDate);
    taskService.addTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text("Data: ${selectedDate.toLocal().toString().split(' ')[0]}"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: const Text('Salvar Tarefa')),
          ],
        ),
      ),
    );
  }
}
