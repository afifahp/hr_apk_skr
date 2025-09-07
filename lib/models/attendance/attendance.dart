class Attendance {
  final String id;              // primary key (misalnya "name" di Frappe)
  final String employee;        // ID karyawan
  final String employeeName;    // nama karyawan
  final String department;      // departemen karyawan
  final String status;          // Hadir/Alpa/Cuti/WFH dll
  final DateTime attendanceDate;
  final String? intime;
  final String? checkOut;

  // Approval-related
  final String approvalStatus;  // Pending/Approved/Rejected
  final String approverRole;    // HR/Chief/etc

  Attendance({
    this.id = "",
    required this.employee,
    required this.employeeName,
    required this.department,
    required this.status,
    required this.attendanceDate,
    this.intime,
    this.checkOut,
    this.approvalStatus = "Pending",
    this.approverRole = "",
  });

  /// Factory from JSON (misalnya dari Frappe API)
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['name'] ?? '', // di Frappe primary key biasanya "name"
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      department: json['department'] ?? '',
      status: json['status'] ?? '',
      attendanceDate: DateTime.tryParse(json['attendance_date'] ?? '') ?? DateTime.now(),
      intime: json['in_time'],
      checkOut: json['check_out'],
      approvalStatus: json['approval_status'] ?? 'Pending',
      approverRole: json['approver_role'] ?? '',
    );
  }

  /// Convert ke JSON (misalnya buat dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      "name": id,
      "employee": employee,
      "employee_name": employeeName,
      "department": department,
      "status": status,
      "attendance_date": attendanceDate.toIso8601String(),
      "check_in": intime,
      "check_out": checkOut,
      "approval_status": approvalStatus,
      "approver_role": approverRole,
    };
  }

  /// Label status biar lebih user-friendly
  String get statusLabel {
    switch (status.toLowerCase()) {
      case "present":
        return "Hadir";
      case "absent":
        return "Alpa";
      case "on leave":
        return "Cuti";
      case "wfh":
        return "WFH";
      default:
        return status;
    }
  }

  /// Convenience getters
  bool get isApproved => approvalStatus.toLowerCase() == "approved";
  bool get isRejected => approvalStatus.toLowerCase() == "rejected";
  bool get isPending => approvalStatus.toLowerCase() == "pending";

  /// Format tanggal biar gampang dipakai di UI
  String get formattedDate =>
      "${attendanceDate.day.toString().padLeft(2, '0')}-"
      "${attendanceDate.month.toString().padLeft(2, '0')}-"
      "${attendanceDate.year}";
}
