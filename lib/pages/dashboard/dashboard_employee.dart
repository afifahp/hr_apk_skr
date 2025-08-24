import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../widgets/app_button.dart'; // pake AppButton kamu

class DashboardEmployee extends StatefulWidget {
  final User user;

  const DashboardEmployee({super.key, required this.user});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  bool isCheckedIn = false; // status awal check-in

  void _toggleAttendance() {
    setState(() {
      isCheckedIn = !isCheckedIn;
    });

    // TODO: panggil AttendanceService API
    if (isCheckedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Berhasil Check-In")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🚪 Berhasil Check-Out")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Button Check-In / Check-Out
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              type: isCheckedIn ? ButtonType.checkOut : ButtonType.checkIn,
              onPressed: _toggleAttendance,
            ),
          ),

          // 🔹 Menu Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard(context, "Absensi", Icons.access_time, "/attendance"),
                _buildCard(context, "Cuti / Izin", Icons.beach_access, "/leave"),
                _buildCard(context, "Slip Gaji", Icons.receipt_long, "/salary"),
              ],
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
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
