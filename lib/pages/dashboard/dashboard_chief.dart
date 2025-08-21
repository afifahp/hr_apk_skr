import 'package:flutter/material.dart';

class DashboardChief extends StatelessWidget {
  final String subRole; // contoh: "cfo" atau "cto" atau "coo"

  DashboardChief({required this.subRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard Chief Officer")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(context, "Approval Cuti", Icons.approval, "/leaveApproval"),
          _buildCard(context, "Data Karyawan", Icons.people, "/employee"),
          _buildCard(context, "Laporan Absensi", Icons.assignment, "/attendance"),

          // khusus CFO ada menu tambahan
          if (subRole.toLowerCase() == "cfo")
            _buildCard(context, "Riwayat Gaji", Icons.receipt_long, "/salary"),
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
              Icon(icon, size: 40, color: Colors.orange),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
