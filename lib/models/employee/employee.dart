class Employee {
  final String id;
  final String name;
  final String department;
  final String position;
  final String reportTo;
  final int leaveBalance; //ini udah ada di doctype leave request T_T, tp gak ada di doctype employee
  final List<String> holidays;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.position,
    required this.reportTo,
    required this.leaveBalance,
    required this.holidays,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"] ?? "-",
      name: json["name"] ?? "-",
      department: json["department"] ?? "-",
      position: json["position"] ?? "-",
      reportTo: json["report_to"] ?? "-",
      leaveBalance: json["leave_balance"] ?? 0,
      holidays: (json["holidays"] as List<dynamic>?)
              ?.map((h) => h.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "department": department,
      "position": position,
      "report_to": reportTo,
      "leave_balance": leaveBalance,
      "holidays": holidays,
    };
  }
}
