class SalaryHistory {
  final String id;       // contoh: "2024-10"
  final String name;     // contoh: "Oktober 2024"

  SalaryHistory({
    required this.id,
    required this.name,
  });

  factory SalaryHistory.fromJson(Map<String, dynamic> json) {
    return SalaryHistory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
