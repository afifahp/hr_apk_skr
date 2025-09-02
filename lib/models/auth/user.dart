class User {
  final String id;             // PK dari Frappe (field "name")
  final String email;
  final String role;           // employee, hr, chief
  final String subRole;        // khusus Chief: cfo, cto, dll
  final String token;          // session/JWT token
  final String employeeName;   // Nama karyawan
  final String department;     // Departemen
  final String jobPosition;    // Posisi/Jabatan
  final String leaveApprover;  // ✅ mandatory

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.subRole,
    required this.token,
    required this.employeeName,
    required this.department,
    required this.jobPosition,
    required this.leaveApprover,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["name"] ?? "", // biasanya PK di Frappe
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      subRole: json["subRole"] ?? "",
      token: json["token"] ?? "",
      employeeName: json["employee_name"] ?? json["employeeName"] ?? "",
      department: json["department"] ?? "",
      jobPosition: json["job_position"] ?? json["jobPosition"] ?? "",
      leaveApprover: json["leave_approver"] ?? json["approver_name"] ?? "", // ✅ default ke ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "role": role,
      "subRole": subRole,
      "token": token,
      "employee_name": employeeName,
      "department": department,
      "job_position": jobPosition,
      "leave_approver": leaveApprover,
    };
  }

  // ✅ alias biar gampang dipakai
  String get name => employeeName;

  // Getter role-based
  bool get isEmployee => role.toLowerCase() == "employee";
  bool get isHR => role.toLowerCase() == "hr";
  bool get isChief => role.toLowerCase() == "chief";

  bool get isCFO => isChief && subRole.toLowerCase() == "cfo";
  bool get isOtherChief => isChief && subRole.toLowerCase() != "cfo";

  bool get canAccessSalary => isEmployee || isHR || isCFO;
  bool get canApproveLeave => isChief; // ✅ hanya Chief yang bisa approve
}
