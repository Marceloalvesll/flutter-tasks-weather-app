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

    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Data: $formattedDate"),
            const SizedBox(height: 8),
            Text("Descrição: ${task.description.isEmpty ? 'Nenhuma' : task.description}"),
            const Divider(height: 30),
            const Text("🌤️ Previsão do Tempo", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : weatherData == null
                ? const Text("Erro ao obter previsão do tempo.")
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cidade: ${weatherData!['location']['name']}"),
                Text("Condição: ${weatherData!['forecast']['forecastday'][0]['day']['condition']['text']}"),
                Text("Temperatura Máxima: ${weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c']} °C"),
                Text("Temperatura Mínima: ${weatherData!['forecast']['forecastday'][0]['day']['mintemp_c']} °C"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
