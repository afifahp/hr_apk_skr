class WfaRequest {   //ini bikin doctypenya di frappeeeee
  final String id;
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String approvalStatus; // pending, approved, rejected
  final String approverRole;   // HR / CO yang bisa approve
  final DateTime requestDate;

  WfaRequest({
    required this.id,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.approvalStatus,
    required this.approverRole,
    required this.requestDate,
  });

  factory WfaRequest.fromJson(Map<String, dynamic> json) {
    return WfaRequest(
      id: json["id"] ?? "",
      employeeId: json["employee_id"] ?? "",
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"]),
      reason: json["reason"] ?? "-",
      approvalStatus: json["approval_status"] ?? "pending",
      approverRole: json["approver_role"] ?? "",
      requestDate: DateTime.parse(json["request_date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee_id": employeeId,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "reason": reason,
      "approval_status": approvalStatus,
      "approver_role": approverRole,
      "request_date": requestDate.toIso8601String(),
    };
  }

  /// Label lebih enak dibaca di UI
  String get statusLabel {
    switch (approvalStatus.toLowerCase()) {
      case "pending":
        return "Menunggu Persetujuan";
      case "approved":
        return "Disetujui";
      case "rejected":
        return "Ditolak";
      default:
        return approvalStatus;
    }
  }
}
