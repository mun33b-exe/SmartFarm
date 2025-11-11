import 'package:flutter/material.dart';

import '../models/crop_tip.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final data = await WeatherService().fetchWeather();
      if (!mounted) return;
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load weather data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome, Farmer')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weatherData == null
          ? const Center(child: Text('Unable to load weather data.'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWeatherCard(context),
                    const SizedBox(height: 24),
                    Text(
                      '5-Day Forecast',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _buildForecastList(),
                    const SizedBox(height: 24),
                    Text(
                      "Today's Tips",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _buildCropTipsList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    final current = _weatherData!['current'] as Map<String, dynamic>;

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Islamabad',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "${current['temperature_2m']}°C",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Weather data by Open-Meteo.com',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.wb_sunny,
              size: 80,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastList() {
    final daily = _weatherData!['daily'] as Map<String, dynamic>;
    final times = (daily['time'] as List).cast<String>();
    final temps = (daily['temperature_2m_max'] as List).cast<num>();
    final itemCount = times.length < 5 ? times.length : 5;

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(times[index].substring(5, 10)),
                    const SizedBox(height: 8),
                    const Icon(Icons.cloud_queue, size: 30),
                    const SizedBox(height: 8),
                    Text('${temps[index]}°C'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCropTipsList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: CropTip.dummyTips.length,
        itemBuilder: (context, index) {
          final tip = CropTip.dummyTips[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 8.0),
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tip.icon, style: const TextStyle(fontSize: 30)),
                    Text(
                      tip.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        tip.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
