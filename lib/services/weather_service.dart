import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "803d2f0bc40f4b1e9fd210917252703";

  Future<Map<String, dynamic>> fetchWeather(String city, DateTime date) async {
    String formattedDate = date.toIso8601String().split('T').first;

    final url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&dt=$formattedDate");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao carregar previsão do tempo");
    }
  }
}
