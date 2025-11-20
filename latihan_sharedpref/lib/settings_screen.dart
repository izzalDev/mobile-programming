import 'package:flutter/material.dart';
import 'package:latihan_sharedpref/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                subtitle: Text('Enable dark theme'),
                value: settings.isDarkMode,
                onChanged: (value) {
                  settings.toggleDarkMode();
                },
              ),
              Divider(),
              SwitchListTile(
                title: Text('Notifications'),
                subtitle: Text('Enable push notifications'),
                value: settings.isNotificationEnabled,
                onChanged: (value) {
                  settings.toggleNotifications();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
