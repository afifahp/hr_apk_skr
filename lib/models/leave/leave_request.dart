class LeaveRequest {
  final int id;
  final String employeeId;
  final String employeeName;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // Pending, Approved, Rejected
  final String? approver; // siapa yang approve/decline (Chief)

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.approver,
  });

  String get dateRange =>
      "${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}";

  /// Convert JSON ke model
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] ?? 0,
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      reason: json['reason'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
      approver: json['approver'],
    );
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'reason': reason,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'approver': approver,
    };
  }
}
