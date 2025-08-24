//list attendance keseluruhan

import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';
import '../../models/auth/user.dart';

class AttendancePage extends StatelessWidget {
  final User user; // langsung passing User object
  final List<Attendance> attendances;

  const AttendancePage({
    super.key,
    required this.user,
    required this.attendances,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Kehadiran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          final attendance = attendances[index];

          if (user.isEmployee) {
            // === EMPLOYEE ===
            return ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(attendance.statusLabel),
              subtitle: Text(
                _formatDate(attendance.date),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/attendance/detail',
                  arguments: attendance,
                );
              },
            );
          } else {
            // === HR / CO / CFO ===
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text("Employee: ${attendance.employeeId}"),
              subtitle: Text(
                _formatDate(attendance.date),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/attendance/detail',
                  arguments: attendance,
                );
              },
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
           "${date.month.toString().padLeft(2, '0')}/"
           "${date.year}";
  }
}
