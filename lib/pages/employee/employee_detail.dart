import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String employeeId;
  final String name;
  final String department;
  final String reportTo;
  final int leaveBalance;
  final List<String> holidays;

  const EmployeeDetailPage({
    super.key,
    required this.employeeId,
    required this.name,
    required this.department,
    required this.reportTo,
    required this.leaveBalance,
    required this.holidays,
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
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
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

            _buildReadOnlyField("ID", employeeId),
            _buildReadOnlyField("Nama", name),
            _buildReadOnlyField("Posisi/Dept", department),
            _buildReadOnlyField("Report to", reportTo),
            _buildReadOnlyField("Sisa Cuti", "$leaveBalance hari"),
            _buildReadOnlyField("Daftar Hari Libur", holidays.join(", ")),

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
            width: 100,
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
