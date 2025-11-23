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
  String _selectedCrop = 'Wheat';

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
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Wheat', label: Text('Wheat')),
                        ButtonSegment(value: 'Rice', label: Text('Rice')),
                        ButtonSegment(value: 'Cotton', label: Text('Cotton')),
                      ],
                      selected: {_selectedCrop},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedCrop = newSelection.first;
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color,
                        selectedBackgroundColor: Theme.of(context).primaryColor,
                        selectedForegroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCropTipsList(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Government Schemes',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSchemeCard(
                      context,
                      title: 'CM Punjab Kisan Card',
                      description:
                          'Provides interest-free agricultural loans up to Rs. 150,000 for 5 acres. Also includes subsidies on fertilizers and seeds.',
                      icon: Icons.credit_card,
                    ),
                    _buildSchemeCard(
                      context,
                      title: 'Punjab Agriculture Subsidy 2025',
                      description:
                          'Get up to 60% subsidy on modern agricultural machinery like seed drills, laser levelers, and sprayers.',
                      icon: Icons.precision_manufacturing,
                    ),
                    _buildSchemeCard(
                      context,
                      title: 'Green Tractor Scheme (Phase 2)',
                      description:
                          '70% subsidy for small tractors and 50% for large tractors for farmers with 12.5 acres or less.',
                      icon: Icons.agriculture,
                    ),
                    _buildSchemeCard(
                      context,
                      title: 'Direct Fertilizer Subsidy',
                      description:
                          'Get a cash subsidy on DAP and Potassium fertilizers. Find the voucher inside the bag and redeem it.',
                      icon: Icons.savings,
                    ),
                    const SizedBox(height: 16),
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
    final tips = CropTip.filteredTips[_selectedCrop] ?? [];

    return Column(
      children: tips.map((tip) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Text(tip.icon, style: const TextStyle(fontSize: 30)),
            title: Text(
              tip.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(tip.description),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
