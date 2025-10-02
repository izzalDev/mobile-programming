import 'package:flutter/material.dart';

class StudentInfoCart extends StatelessWidget {
  final String name;
  final String nim;
  final String major;
  final int semester;

  const StudentInfoCart(
      {super.key,
      required this.name,
      required this.nim,
      required this.major,
      required this.semester});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Mahasiswa',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700]),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildInfoRow('Nama', name),
            _buildInfoRow('NIM', nim),
            _buildInfoRow('Jurusan', major),
            _buildInfoRow('Semester', semester.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text('$label: $value'));
  }
}
