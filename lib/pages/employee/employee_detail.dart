import 'package:flutter/material.dart';
import '../../models/employee/employee.dart';
import '../../models/auth/user.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;
  final User user;

  const EmployeeDetailPage({
    super.key,
    required this.employee,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar inisial nama
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.indigo,
                child: Text(
                  employee.employeeName.isNotEmpty
                      ? employee.employeeName[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Detail Karyawan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            _buildReadOnlyField("ID", employee.id ?? "-"),
            _buildReadOnlyField("Nama", employee.employeeName),
            _buildReadOnlyField("Posisi/Dept",
                "${employee.jobPosition ?? '-'} / ${employee.department ?? '-'}"),
            _buildReadOnlyField("Leave Approver", user.leaveApprover ?? "-"),
            _buildReadOnlyField(
                "Sisa Cuti", "${employee.leaveBalance ?? 0} hari"),
            _buildReadOnlyField(
              "Daftar Hari Libur",
              (employee.upcomingHolidays == null ||
                      employee.upcomingHolidays!.isEmpty)
                  ? "-"
                  : employee.upcomingHolidays!
                      .map((e) =>
                          "${e['holiday_name'] ?? '-'} (${e['holiday_date'] ?? '-'})")
                      .join(", "),
            ),

            const Spacer(),

            // Tombol selesai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Selesai"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper buat field read-only
  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
