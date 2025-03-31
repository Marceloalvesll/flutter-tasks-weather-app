import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const TaskFormScreen({super.key, this.task, this.index});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TaskService taskService = TaskService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = widget.task!.date;
    }
  }

  void submit() {
    final newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );

    if (widget.task == null) {
      taskService.addTask(newTask);
    } else {
      taskService.updateTask(widget.index!, newTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Tarefa" : "Nova Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text("Data: ${selectedDate.toLocal().toString().split(' ')[0]}"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.isBefore(DateTime.now())
                      ? DateTime.now()
                      : selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 14)), // limite do plano gratuito
                );

                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: Text(isEditing ? 'Salvar Alterações' : 'Salvar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
