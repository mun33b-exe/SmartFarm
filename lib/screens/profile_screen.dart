import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const ProfileScreen({super.key, required this.changeTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String _userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'Unknown user';
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  child: Text(_userEmail.isNotEmpty
                      ? _userEmail[0].toUpperCase()
                      : '?'),
                ),
                title: const Text('Signed in as'),
                subtitle: Text(_userEmail),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'App Theme',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _buildThemeSwitcher(context),
            const SizedBox(height: 24),
            Text(
              'Farmer Schemes & Info',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildInfoCards(context),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text('Light'),
          icon: Icon(Icons.wb_sunny),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('System'),
          icon: Icon(Icons.brightness_auto),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text('Dark'),
          icon: Icon(Icons.nightlight_round),
        ),
      ],
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        final theme = newSelection.first;
        setState(() {
          _selectedTheme = theme;
        });
        widget.changeTheme(theme);
      },
      selected: {_selectedTheme},
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final infoItems = [
      (
        title: 'Crop Insurance',
        description: 'Protect your harvest with government-backed schemes. '
            'Visit the local agriculture office for enrollment.',
        icon: Icons.shield,
      ),
      (
        title: 'Soil Testing',
        description: 'Free soil health analysis provided quarterly. '
            'Schedule a visit through the agriculture hotline.',
        icon: Icons.science,
      ),
      (
        title: 'Market Intelligence',
        description: 'Daily commodity prices updated at 6 AM via SMS alerts. '
            'Subscribe to stay informed.',
        icon: Icons.bar_chart,
      ),
    ];

    return Column(
      children: infoItems
          .map(
            (item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(item.icon, color: Theme.of(context).primaryColor),
                title: Text(item.title),
                subtitle: Text(item.description),
              ),
            ),
          )
          .toList(),
    );
  }
}
