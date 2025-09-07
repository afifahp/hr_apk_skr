class LeaveRequest {
  final int id;
  final String employeeName;
  final String jobPosition;
  final String department;
  final String descLeave;
  final DateTime fromDate;
  final DateTime toDate;
  final String leaveType;
  final String status;
  final String leaveApprover;
  final int halfDay;
  final String? attachment;

  LeaveRequest({
    required this.id,
    required this.employeeName,
    required this.jobPosition,
    required this.department,
    required this.descLeave,
    required this.fromDate,
    required this.toDate,
    required this.leaveType,
    required this.status,
    required this.leaveApprover,
    required this.halfDay,
    this.attachment,
  });

  /// Getter untuk range tanggal
  String get dateRange =>
      "${fromDate.toString().split(' ')[0]} - ${toDate.toString().split(' ')[0]}";

  /// Convert JSON ke model
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    String rawStatus = (json['status'] ?? 'Pending').toString();

    // ✅ Mapping status backend → Flutter yang lebih komprehensif
    String mappedStatus;
    switch (rawStatus.toLowerCase()) {
      case "open":
      case "pending":
        mappedStatus = "Pending";
        break;
      case "approved":
      case "approve":
      case "disetujui":
        mappedStatus = "Approved";
        break;
      case "rejected":
      case "reject":
      case "ditolak":
        mappedStatus = "Rejected";
        break;
      case "cancelled":
      case "cancel":
      case "dibatalkan":
        mappedStatus = "Cancelled";
        break;
      default:
        mappedStatus = rawStatus;
    }

    return LeaveRequest(
      id: json['id'] ?? 0,
      employeeName: json['employee_name'] ?? json['employeeName'] ?? '',
      jobPosition: json['job_position'] ?? json['jobPosition'] ?? '',
      department: json['department'] ?? '',
      descLeave: json['desc_leave'] ?? json['descLeave'] ?? '',
      fromDate: DateTime.tryParse(json['from_date'] ?? json['fromDate'] ?? '') ?? DateTime.now(),
      toDate: DateTime.tryParse(json['to_date'] ?? json['toDate'] ?? '') ?? DateTime.now(),
      leaveType: json['leave_type'] ?? json['leaveType'] ?? 'Tahunan',
      status: mappedStatus,
      leaveApprover: json['leave_approver'] ?? json['leaveApprover'] ?? '',
      halfDay: _parseHalfDay(json['half_day'] ?? json['halfDay']),
      attachment: json['attachment'],
    );
  }

  /// 🔹 Helper untuk parsing halfDay
  static int _parseHalfDay(dynamic halfDayValue) {
    if (halfDayValue is int) return halfDayValue;
    if (halfDayValue is String) return int.tryParse(halfDayValue) ?? 0;
    return 0;
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    // ✅ Mapping status Flutter → backend yang konsisten
    String mappedStatus;
    switch (status.toLowerCase()) {
      case "pending":
        mappedStatus = "Open"; // Sesuai dengan Frappe/ERPNext
        break;
      case "approved":
        mappedStatus = "Approved";
        break;
      case "rejected":
        mappedStatus = "Rejected";
        break;
      case "cancelled":
        mappedStatus = "Cancelled";
        break;
      default:
        mappedStatus = status;
    }

    return {
      'id': id,
      'employee_name': employeeName,
      'job_position': jobPosition,
      'department': department,
      'desc_leave': descLeave,
      'from_date': fromDate.toIso8601String().split('T')[0],
      'to_date': toDate.toIso8601String().split('T')[0],
      'leave_type': leaveType,
      'status': mappedStatus,
      'leave_approver': leaveApprover,
      'half_day': halfDay,
      'attachment': attachment,
    };
  }

  /// 🔹 TAMBAHKAN METHOD copyWith
  LeaveRequest copyWith({
    int? id,
    String? employeeName,
    String? jobPosition,
    String? department,
    String? descLeave,
    DateTime? fromDate,
    DateTime? toDate,
    String? leaveType,
    String? status,
    String? leaveApprover,
    int? halfDay,
    String? attachment,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      jobPosition: jobPosition ?? this.jobPosition,
      department: department ?? this.department,
      descLeave: descLeave ?? this.descLeave,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      leaveType: leaveType ?? this.leaveType,
      status: status ?? this.status,
      leaveApprover: leaveApprover ?? this.leaveApprover,
      halfDay: halfDay ?? this.halfDay,
      attachment: attachment ?? this.attachment,
    );
  }
}