class Employee {
  final String id;
  final String employeeName;   // alias untuk full_name atau employee_name
  final String department;
  final String jobPosition;   // alias untuk job_position atau designation
  final String status;
  final int leaveBalance;      // sisa cuti
  final List<Map<String, dynamic>> upcomingHolidays; // hari libur mendatang

  Employee({
    required this.id,
    required this.employeeName,
    required this.department,
    required this.jobPosition,
    required this.status,
    this.leaveBalance = 0,
    this.upcomingHolidays = const [],
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'] ?? json['name'] ?? '',
        employeeName: json['full_name'] ?? json['employee_name'] ?? '',
        department: json['department'] ?? '',
        jobPosition: json['job_position'] ?? json['designation'] ?? '',
        status: json['status'] ?? '',
        leaveBalance: json['leave_balance'] ?? 0,
        upcomingHolidays: (json['upcoming_holidays'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee_name": employeeName,
      "department": department,
      "job_position": jobPosition,
      "status": status,
      "leave_balance": leaveBalance,
      "upcoming_holidays": upcomingHolidays,
    };
  }
}
