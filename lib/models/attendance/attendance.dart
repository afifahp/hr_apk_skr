class Attendance {
  final String id;
  final String employeeId;
  final DateTime date;
  final String status;
  final String approvalStatus;
  final String approverRole;

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
      id: json['id'],
      employeeId: json['employee_id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      approvalStatus: json['approval_status'],
      approverRole: json['approver_role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'date': date.toIso8601String(),
        'status': status,
        'approval_status': approvalStatus,
        'approver_role': approverRole,
      };

  /// ✅ Getter HARUS di dalam class ini
  String get statusLabel {
    switch (status.toLowerCase()) {
      case "hadir_wfo":
        return "Hadir - WFO";
      case "hadir_wfh/a":
        return "Hadir - WFH/A";
      case "izin":
        return "Izin";
      case "cuti":
        return "Cuti";
      case "alpha":
        return "Alpha";
      default:
        return status;
    }
  }
}
