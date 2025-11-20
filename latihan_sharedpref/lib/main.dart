import 'package:flutter/material.dart';
import 'package:latihan_sharedpref/settings_provider.dart';
import 'package:latihan_sharedpref/settings_screen.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider()..loadSettings(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        if (settings.isLoading) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return MaterialApp(
          title: "Settings App",
          theme: settings.isDarkMode ? ThemeData.dark() : .light(),
          home: SettingsScreen(),
        );
      },
    );
  }
}
