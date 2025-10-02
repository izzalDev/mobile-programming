import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String email;
  final String phone;

  const ContactCard({super.key, required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.green.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_phone, color: Colors.green[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Kontak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildContactItem(Icons.email, 'Email', email),
            const SizedBox(height: 12),
            _buildContactItem(Icons.phone, 'Telepon', phone),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            // TAMBAH: Expanded untuk flexible width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // TAMBAH: Handle text overflow
                  maxLines: 2, // TAMBAH: Allow 2 lines untuk email panjang
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
