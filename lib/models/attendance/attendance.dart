class Attendance { //untuk frappe, fieldnya dari sini
  final String id;
  final String employeeId;
  final String name;        // ✅ nama karyawan
  final String dept;        // ✅ dept / posisi
  final DateTime date;
  final String status;
  final String approvalStatus;
  final String approverRole;
  final String reason;      // ✅ alasan/keterangan


  Attendance({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.dept,
    required this.date,
    required this.status,
    required this.approvalStatus,
    required this.approverRole,
    required this.reason,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      employeeId: json['employee_id'],
      name: json['name'] ?? "-",               // default placeholder
      dept: json['dept'] ?? "-",
      date: DateTime.parse(json['date']),
      status: json['status'],
      approvalStatus: json['approval_status'],
      approverRole: json['approver_role'],
      reason: json['reason'] ?? "-",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'name': name,
        'dept': dept,
        'date': date.toIso8601String(),
        'status': status,
        'approval_status': approvalStatus,
        'approver_role': approverRole,
        'reason': reason,
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
