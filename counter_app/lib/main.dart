import 'package:flutter/material.dart';

// Entry point aplikasi Flutter
void main() {
  runApp(MyApp());
}

// Root widget aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      home: CounterPage(),
    );
  }
}

// Halaman counter dengan state
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0; // Variable untuk menyimpan nilai counter

  // Method untuk menambah counter
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Click Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Anda menekan tombol sebanyak:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // Menggunakan custom widget CounterButton
            CounterButton(
              onPressed: _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget untuk tombol (demonstrasi widget composition)
class CounterButton extends StatelessWidget {
  final VoidCallback onPressed;

  CounterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Tambah +1'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}
