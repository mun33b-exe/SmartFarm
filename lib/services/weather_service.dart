import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=33.74&longitude=73.13&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load weather');
  }
}
