import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  final box = await Hive.openBox<Task>('tasks');

  // Adiciona tarefas exemplo se estiver vazio
  if (box.isEmpty) {
    await _adicionarTarefasExemplo(box);
  }

  runApp(const MyApp());
}

Future<void> _adicionarTarefasExemplo(Box<Task> box) async {
  final tarefasExemplo = [
    Task(
      title: 'Estudar Flutter',
      date: DateTime.now().add(const Duration(days: 1)),
      description: 'Revisar widgets básicos e gerenciar estado.',
    ),
    Task(
      title: 'Fazer compras',
      date: DateTime.now().add(const Duration(days: 2)),
      description: 'Ir ao mercado e comprar frutas.',
    ),
    Task(
      title: 'Treino na academia',
      date: DateTime.now(),
      description: 'Treino de peito e tríceps.',
    ),
    Task(
      title: 'Projeto da escola',
      date: DateTime.now().add(const Duration(days: 3)),
      description: 'Terminar o slide para a apresentação.',
    ),
  ];

  await box.addAll(tarefasExemplo);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

