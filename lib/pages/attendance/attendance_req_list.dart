import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';
import '../../utils/role_manager.dart';

class AttendanceRequestList extends StatelessWidget {
  final List<Attendance> attendances;
  final String role;
  final String? subRole;

  const AttendanceRequestList({
    super.key,
    required this.attendances,
    required this.role,
    this.subRole,
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
              "${attendance.statusLabel} - ${attendance.date.toLocal()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Approval: ${attendance.approvalStatus}"),
            trailing: _buildTrailing(context, attendance),
          ),
        );
      },
    );
  }

  Widget _buildTrailing(BuildContext context, Attendance attendance) {
    // EMPLOYEE → tidak ada tombol
    if (RoleManager.isEmployee(role)) {
      return const SizedBox.shrink();
    }

    // HR → bisa Approve/Reject semua request
    if (RoleManager.isHR(role)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              _approveRequest(context, attendance);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              _rejectRequest(context, attendance);
            },
          ),
        ],
      );
    }

    // Chief → beda lagi berdasarkan subRole
    if (RoleManager.isChief(role)) {
      // CFO → bisa approve semua + salary access
      if (RoleManager.isCFO(role, subRole)) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                _approveRequest(context, attendance);
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                _rejectRequest(context, attendance);
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long, color: Colors.blue),
              onPressed: () {
                // navigasi ke Salary page
                Navigator.pushNamed(context, "/salary");
              },
            ),
          ],
        );
      }

      // Chief lain (CTO, COO, dll) → hanya approve/reject divisinya
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              _approveRequest(context, attendance);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              _rejectRequest(context, attendance);
            },
          ),
        ],
      );
    }

    // fallback
    return const SizedBox.shrink();
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
