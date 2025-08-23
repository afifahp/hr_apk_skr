import 'package:flutter/material.dart';
import '../models/attendance.dart';

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

            _buildDetailRow("ID", attendance.employeeId),
            _buildDetailRow("Nama", "Karyawan 1"), // nanti ambil dari DB karyawan
            _buildDetailRow("Posisi/Dept", "QA - IT"), // sementara dummy
            _buildDetailRow("Kehadiran", "Hadir - ${attendance.status}"),

            const SizedBox(height: 16),
            const Text("Jam",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check-in 08:30"), // sementara hardcode
                Text(
                  "Terlambat 30 menit",
                  style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text("Check-out  --:--"),

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
                child: const Text("WFH karena urusan keluarga"),
              ),

              const SizedBox(height: 16),
              const Text("Approval",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),

              _buildDetailRow("Pemberi Izin", attendance.approverRole),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  Text(
                    attendance.approvalStatus.toUpperCase(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
