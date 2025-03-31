import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../services/weather_service.dart';
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
  final WeatherService weatherService = WeatherService();
  late List<Task> tasks;
  Map<int, String> weatherSummaries = {};

  @override
  void initState() {
    super.initState();
    tasks = taskService.getAllTasks();
    fetchWeatherForTasks();
  }

  void fetchWeatherForTasks() async {
    for (int i = 0; i < tasks.length; i++) {
      try {
        final data = await weatherService.fetchWeather("Palmas", tasks[i].date);
        final max = data['forecast']['forecastday'][0]['day']['maxtemp_c'];
        final min = data['forecast']['forecastday'][0]['day']['mintemp_c'];
        setState(() {
          weatherSummaries[i] = "Máx: ${max}°C / Mín: ${min}°C";
        });
      } catch (_) {
        setState(() {
          weatherSummaries[i] = "Clima indisponível";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Tarefas')),
      body: tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa encontrada'))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          final dateText = DateFormat('dd/MM/yyyy').format(task.date);
          final weather = weatherSummaries[index] ?? "Carregando clima...";

          return ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateText),
                Text(weather, style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  taskService.deleteTask(index);
                  tasks = taskService.getAllTasks();
                  weatherSummaries.remove(index);
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailScreen(task: task),
                ),
              );
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(
                    task: task,
                    index: index,
                  ),
                ),
              ).then((_) {
                setState(() {
                  tasks = taskService.getAllTasks();
                  fetchWeatherForTasks();
                });
              });
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
          ).then((_) => setState(() {
            tasks = taskService.getAllTasks();
            fetchWeatherForTasks();
          }));
        },
      ),
    );
  }
}
