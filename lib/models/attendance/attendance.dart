class Attendance {
  final String id;
  final String employeeId;
  final DateTime date;
  final String status; // hadir, izin, cuti, alpha
  final String approvalStatus; // pending, approved, rejected
  final String approverRole; // role yg bisa approve

  Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
    required this.approvalStatus,
    required this.approverRole,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? '',
      approvalStatus: json['approval_status'] ?? 'pending',
      approverRole: json['approver_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date.toIso8601String(),
      'status': status,
      'approval_status': approvalStatus,
      'approver_role': approverRole,
    };
  }
}
