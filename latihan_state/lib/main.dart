import 'package:flutter/material.dart';
import 'package:latihan_state/counter_provider.dart';
import 'package:latihan_state/counter_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CounterProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const CounterScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
