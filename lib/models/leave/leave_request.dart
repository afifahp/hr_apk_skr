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
  final String leaveApprover; // <- fix
  final int halfDay; // 0 atau 1
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
    required this.leaveApprover, // <- fix
    required this.halfDay,
    this.attachment,
  });

  /// Getter untuk range tanggal
  String get dateRange =>
      "${fromDate.toString().split(' ')[0]} - ${toDate.toString().split(' ')[0]}";

  /// Convert JSON ke model
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      jobPosition: json['job_position'] ?? '',
      department: json['department'] ?? '',
      descLeave: json['desc_leave'] ?? '',
      fromDate: DateTime.tryParse(json['from_date'] ?? '') ?? DateTime.now(),
      toDate: DateTime.tryParse(json['to_date'] ?? '') ?? DateTime.now(),
      leaveType: json['leave_type'] ?? 'Tahunan',
      status: json['status'] ?? 'Pending',
      leaveApprover: json['leave_approver'] ?? '', // <- fix
      halfDay: json['half_day'] is int
          ? json['half_day']
          : int.tryParse(json['half_day']?.toString() ?? '0') ?? 0,
      attachment: json['attachment'],
    );
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'job_position': jobPosition,
      'department': department,
      'desc_leave': descLeave,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'leave_type': leaveType,
      'status': status,
      'leave_approver': leaveApprover, // <- fix
      'half_day': halfDay,
      'attachment': attachment,
    };
  }
}
