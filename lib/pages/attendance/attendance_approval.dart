import 'package:flutter/material.dart';

class AttendanceApprovalPage extends StatelessWidget {
  final String id;
  final String name;
  final String dept;
  final String reason;
  final String approver;
  final String status;
  final bool isReadOnly; // true kalau HR

  const AttendanceApprovalPage({
    super.key,
    required this.id,
    required this.name,
    required this.dept,
    required this.reason,
    required this.approver,
    required this.status,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pengajuan WFH/A")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Karyawan", style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),

            Text("ID: $id"),
            Text("Nama: $name"),
            Text("Dept: $dept"),
            const SizedBox(height: 10),

            Text("Keterangan: $reason"),
            const SizedBox(height: 10),

            const Text("Approval", style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            Text("Pemberi Izin: $approver"),
            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Status: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  status,
                  style: TextStyle(
                    color: status == "PENDING"
                        ? Colors.amber
                        : status == "APPROVED"
                            ? Colors.green
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            if (!isReadOnly) // tombol hanya untuk CO
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        // TODO: update ke APPROVED via backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Request disetujui")),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Accept"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // TODO: update ke REJECTED via backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Request ditolak")),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
