// file: attendance_page.dart
import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';
import '../../models/auth/user.dart';
import '../../services/attendance_service.dart';

class AttendancePage extends StatefulWidget {
  final User user;

  const AttendancePage({
    super.key,
    required this.user,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<List<Attendance>> _futureAttendances;

  @override
  void initState() {
    super.initState();
    _futureAttendances = AttendanceService.getAllAttendance();
  }

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
      body: FutureBuilder<List<Attendance>>(
        future: _futureAttendances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final attendances = snapshot.data ?? [];

          if (attendances.isEmpty) {
            return const Center(child: Text("Belum ada data kehadiran"));
          }

          return ListView.builder(
            itemCount: attendances.length,
            itemBuilder: (context, index) {
              final attendance = attendances[index];

              // Kalau employee biasa
              if (widget.user.isEmployee) {
                return ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(attendance.statusLabel),
                  subtitle: Text(
                    _formatDate(attendance.attendanceDate),
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
              // Kalau chief/hr/admin dll
              else {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Employee: ${attendance.employeeName} - ${attendance.statusLabel}"),
                  subtitle: Text(
                    _formatDate(attendance.attendanceDate),
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
          );
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
