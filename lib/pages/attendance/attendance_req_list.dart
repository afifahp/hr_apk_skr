import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';
import '../../models/auth/user.dart';
import 'attendance_approval.dart';

class AttendanceRequestList extends StatelessWidget {
  final List<Attendance> attendances;
  final User user;

  const AttendanceRequestList({
    super.key,
    required this.attendances,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: attendances.length,
      itemBuilder: (context, index) {
        final attendance = attendances[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              "${attendance.statusLabel} - ${attendance.attendanceDate.toLocal()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Approval: ${attendance.approvalStatus}"),
            trailing: _buildTrailing(context, attendance),
            onTap: () {
              // 🔹 Navigasi ke halaman detail approval
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceApprovalPage(
                    id: attendance.id,                 // ✅ dari model
                    name: attendance.employeeName,     // ✅ nama karyawan
                    dept: attendance.department,       // ✅ departemen
                    reason: attendance.statusLabel,    // sementara, bisa diganti field alasan
                    approver: attendance.approverRole, // ✅ dari model
                    status: attendance.approvalStatus, // ✅ status approval
                    isReadOnly: user.isHR || user.isEmployee, // ✅ HR & Employee hanya lihat
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrailing(BuildContext context, Attendance attendance) {
    // === EMPLOYEE & HR → read-only, tanpa tombol
    if (user.isEmployee || user.isHR) {
      return const SizedBox.shrink();
    }

    // === Chief (semua CO: CTO, COO, CFO, dll) → bisa approve/reject
    if (user.isChief) {
      return _buildActionButtons(context, attendance);
    }

    // fallback → kosong
    return const SizedBox.shrink();
  }

  /// 🔹 Widget tombol aksi (Approve / Reject)
  Widget _buildActionButtons(BuildContext context, Attendance attendance) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () => _approveRequest(context, attendance),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () => _rejectRequest(context, attendance),
        ),
      ],
    );
  }

  void _approveRequest(BuildContext context, Attendance attendance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Approved request: ${attendance.id}")),
    );
    // TODO: panggil service approve API
  }

  void _rejectRequest(BuildContext context, Attendance attendance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rejected request: ${attendance.id}")),
    );
    // TODO: panggil service reject API
  }
}
