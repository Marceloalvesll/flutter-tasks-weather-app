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
  Map<int, Map<String, dynamic>> weatherData = {};

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
        final day = data['forecast']['forecastday'][0]['day'];
        final max = day['maxtemp_c'];
        final min = day['mintemp_c'];
        final condition = day['condition']['text'];
        final icon = day['condition']['icon'];

        setState(() {
          weatherData[i] = {
            'summary': "Máx: ${max}°C / Mín: ${min}°C",
            'condition': condition,
            'icon': icon
          };
        });
      } catch (_) {
        setState(() {
          weatherData[i] = {
            'summary': "Clima indisponível",
            'icon': null
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: tasks.isEmpty
            ? const Center(
          child: Text(
            'Nenhuma tarefa encontrada',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final task = tasks[index];
            final dateText = DateFormat('dd/MM/yyyy').format(task.date);
            final weather = weatherData[index]?['summary'] ?? "Carregando clima...";
            final iconUrl = weatherData[index]?['icon'];

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: iconUrl != null
                    ? Image.network("https:$iconUrl", width: 48)
                    : const Icon(Icons.wb_cloudy, size: 40),
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(dateText, style: const TextStyle(color: Colors.black54)),
                    Text(weather, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      taskService.deleteTask(index);
                      tasks = taskService.getAllTasks();
                      weatherData.remove(index);
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
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.add, color: Colors.white),
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
      ),
    );
  }
}

