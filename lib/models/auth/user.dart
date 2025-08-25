class User {
  final String id;
  final String name;
  final String email;
  final String role;     // employee, hr, chief
  final String subRole;  // khusus Chief: cfo, cto, dll
  final String token;    // session/JWT token kalau backend kasih

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.subRole,
    required this.token,
  });

  // Parsing dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        role: json["role"] ?? "",
        subRole: json["subRole"] ?? "",
        token: json["token"] ?? "",
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "subRole": subRole,
      "token": token,
    };
  }

  // Getter role-based
  bool get isEmployee => role.toLowerCase() == "employee";
  bool get isHR => role.toLowerCase() == "hr";
  bool get isChief => role.toLowerCase() == "chief";

  // SubRole khusus untuk Chief
  bool get isCFO => isChief && subRole.toLowerCase() == "cfo";
  bool get isOtherChief => isChief && subRole.toLowerCase() != "cfo";

  // Convenience getter (buat kombinasi logika)
  bool get canAccessSalary => isEmployee || isHR || isCFO;
}
