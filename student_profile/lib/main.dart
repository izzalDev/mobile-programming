import 'package:flutter/material.dart';
import 'package:student_profile/screens/profile_screen.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Student Profile',
      home: ProfileScreen(),
    );
  }
}
