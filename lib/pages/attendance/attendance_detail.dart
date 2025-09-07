import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';

class AttendanceDetailPage extends StatelessWidget {
  final Attendance attendance;

  const AttendanceDetailPage({Key? key, required this.attendance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWFH = attendance.status.toLowerCase().contains("wfh") ||
        attendance.status.toLowerCase().contains("wfa");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Kehadiran"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Karyawan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildDetailRow("ID", attendance.employee),          // ✅ pakai employee
            _buildDetailRow("Nama", attendance.employeeName),    // ✅ pakai employeeName
            _buildDetailRow("Dept", attendance.department),      // ✅ department dari model
            _buildDetailRow("Kehadiran", attendance.statusLabel),

            const SizedBox(height: 16),
            const Text("Jam",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check-in ${attendance.intime ?? '--:--'}"),  // ✅ ganti ke intime
                if (attendance.intime != null)
                  Text(
                    "Terlambat?", // TODO: bisa hitung keterlambatan dari aturan jam masuk
                    style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text("Check-out ${attendance.checkOut ?? '--:--'}"),   // ✅ tetap checkOut

            if (isWFH) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              const Text("Keterangan"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("WFH karena urusan keluarga"), // TODO: tambahin field reason di model
              ),

              const SizedBox(height: 16),
              const Text("Approval",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),

              _buildDetailRow("Pemberi Izin", attendance.approverRole ?? "-"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  Text(
                    (attendance.approvalStatus ?? "pending").toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: attendance.approvalStatus == "approved"
                          ? Colors.green
                          : attendance.approvalStatus == "rejected"
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Selesai"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
