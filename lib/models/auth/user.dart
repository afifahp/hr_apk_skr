class User {
  final String id;
  final String name;
  final String email;
  final String role;     // Employee, HR, Chief
  final String subRole;  // khusus Chief: CFO, CTO, dll
  final String token;    // session/JWT token kalau backend kasih

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.subRole,
    required this.token,
  });

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

  bool get isEmployee => role.toLowerCase() == "employee";
  bool get isHR => role.toLowerCase() == "hr";
  bool get isChief => role.toLowerCase() == "chief";
}
