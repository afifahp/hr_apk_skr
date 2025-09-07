class User {
  final String id;
  final String email;
  final String role;       // role profile (e.g., "Management")
  final String subRole;    // sub role (e.g., "Chief Officer")
  final String employeeName;
  final String department;
  final String leaveApprover;
  final List<String> roles; // SEMUA roles yang dimiliki user

  final String? token;
  final String? employee;
  final String? jobPosition;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.subRole,
    required this.employeeName,
    required this.department,
    required this.leaveApprover,
    required this.roles,
    this.token,
    this.employee,
    this.jobPosition,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Ekstrak semua roles dari backend
    List<String> rolesList = [];
    if (json["roles"] != null && json["roles"] is List) {
      rolesList = List<String>.from(json["roles"].map((r) => r.toString()));
    }
    
    // Tambahkan role utama dan subRole jika belum ada
    if (json["role"] != null && !rolesList.contains(json["role"].toString())) {
      rolesList.add(json["role"].toString());
    }
    if (json["subRole"] != null && 
        json["subRole"].toString().isNotEmpty &&
        !rolesList.contains(json["subRole"].toString())) {
      rolesList.add(json["subRole"].toString());
    }

    return User(
      id: json["name"] ?? "",
      email: json["email"] ?? "",
      role: (json["role"] ?? "").toString().trim(),
      subRole: (json["subRole"] ?? "").toString().trim(),
      employeeName: json["full_name"] ?? "",
      department: json["department"] ?? "",
      leaveApprover: json["leave_approver"] ?? "",
      roles: rolesList,
      token: json["token"],
      employee: json["employee"],
      jobPosition: json["jobPosition"],
    );
  }

  // 🔹 Getter yang mengecek SEMUA roles, bukan hanya role profile
  bool get isEmployee {
    return roles.any((r) => r.toLowerCase().contains("employee"));
  }

  bool get isHR {
    return roles.any((r) => r.toLowerCase().contains("hr"));
  }

  bool get isChief {
    return roles.any((r) {
      final roleLower = r.toLowerCase();
      return roleLower.contains("chief") || 
             roleLower.contains("officer") ||
             roleLower == "co";
    });
  }
}