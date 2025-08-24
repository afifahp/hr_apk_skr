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
              "${attendance.statusLabel} - ${attendance.date.toLocal()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Approval: ${attendance.approvalStatus}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AttendanceApprovalPage(
                    id: attendance.id,
                    name: attendance.employeeId, // sementara pake employeeId
                    dept: "-", // ❌ nggak ada di model
                    reason: "-", // ❌ nggak ada di model
                    approver: attendance.approverRole,
                    status: attendance.approvalStatus,
                    isReadOnly: user.isHR || user.isEmployee,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
