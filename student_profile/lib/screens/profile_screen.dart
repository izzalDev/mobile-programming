import 'package:flutter/material.dart';
import 'package:student_profile/widgets/contact_cart.dart';
import 'package:student_profile/widgets/student_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[600]!, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Profil Mahasiswa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Cards
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Column(
                    children: [
                      StudentInfoCart(
                        name: 'Ahmad Hidayat',
                        nim: 'A11.2021.12345',
                        major: 'Teknik Informatika',
                        semester: 5,
                      ),
                      SizedBox(height: 16),
                      ContactCard(
                        email: 'ahmad.hidayat@student.dinus.ac.id',
                        phone: '08123456789',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
