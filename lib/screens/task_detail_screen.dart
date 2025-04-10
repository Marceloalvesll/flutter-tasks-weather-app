import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      weatherData = await weatherService.fetchWeather("Palmas", widget.task.date);
    } catch (e) {
      weatherData = null;
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final formattedDate = DateFormat('dd/MM/yyyy').format(task.date);

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
          title: const Text("Detalhes da Tarefa"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text("Data: $formattedDate", style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Text("Descrição:", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(task.description.isEmpty ? 'Nenhuma' : task.description, style: const TextStyle(color: Colors.white)),
              const Divider(height: 40, color: Colors.white38),
              const Text("🌤️ Previsão do Tempo", style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : weatherData == null
                  ? const Text("Erro ao obter previsão do tempo.", style: TextStyle(color: Colors.white70))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cidade: ${weatherData!['location']['name']}", style: const TextStyle(color: Colors.white70)),
                  Text("Condição: ${weatherData!['forecast']['forecastday'][0]['day']['condition']['text']}", style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thermostat, color: Colors.orangeAccent),
                          const SizedBox(width: 4),
                          Text("Máx: ${weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c']} °C", style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.ac_unit, color: Colors.lightBlueAccent),
                          const SizedBox(width: 4),
                          Text("Mín: ${weatherData!['forecast']['forecastday'][0]['day']['mintemp_c']} °C", style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
