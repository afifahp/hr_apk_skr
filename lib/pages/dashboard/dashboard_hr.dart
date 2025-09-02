import 'package:flutter/material.dart';
import '../../models/auth/user.dart';

import '../auth/login_page.dart'; // pastikan import LoginPage benar

class DashboardHR extends StatelessWidget {
  final User user;

  const DashboardHR({super.key, required this.user});
void _logout(BuildContext context) {
    // Logika logout (hapus token / reset session jika perlu)
    
    // Navigasi langsung ke LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk tabel
    final List<Map<String, String>> dummyEmployees = [
      {
        "ID": "001",
        "Nama": "Fauziyah",
        "Department": "HR",
        "Status": "Aktif"
      },
      {
        "ID": "002",
        "Nama": "Surya",
        "Department": "Finance",
        "Status": "Cuti"
      },
      {
        "ID": "003",
        "Nama": "Rina",
        "Department": "IT",
        "Status": "Aktif"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard HR"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, "Data Karyawan", Icons.people, "/employee"),
          const SizedBox(height: 16),
          _buildCard(context, "Absensi", Icons.access_time, "/attendance"),
          const SizedBox(height: 16),
          _buildCard(context, "Leave Request", Icons.receipt_long, "/leave"),
          const SizedBox(height: 32),

          // Tabel dummy
          const Text(
            "Preview Karyawan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Status')),
              ],
              rows: dummyEmployees.map((emp) {
                return DataRow(
                  cells: [
                    DataCell(Text(emp["ID"]!)),
                    DataCell(Text(emp["Nama"]!)),
                    DataCell(Text(emp["Department"]!)),
                    DataCell(Text(emp["Status"]!)),
                  ],
                );
              }).toList(),
            ),
          ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
