import 'package:flutter/material.dart';
import '../../models/auth/user.dart';

class DashboardHR extends StatelessWidget {
  final User user;

  const DashboardHR({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard HR")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, "Data Karyawan", Icons.people, "/employee"),
          _buildCard(context, "Absensi", Icons.access_time, "/attendance"),
          _buildCard(context, "Slip Gaji", Icons.receipt_long, "/salary"),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
