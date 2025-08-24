class Attendance {
  final String id;
  final String employeeName;
  final String department;
  final String statusLabel; // WFH/A, WFO, dsb
  final DateTime date;
  final String reason;
  final String approver;
  final String approvalStatus; // PENDING / APPROVED / REJECTED


  Attendance({
    required this.id,
    required this.employeeName,
    required this.department,
    required this.statusLabel,
    required this.date,
    required this.reason,
    required this.approver,
    required this.approvalStatus,
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
