class SalaryHistory {
  final String id;        // misal "2025-01"
  final String periodName; // misal "Januari 2025"

  SalaryHistory({
    required this.id,
    required this.periodName,
  });

  factory SalaryHistory.fromJson(Map<String, dynamic> json) {
    return SalaryHistory(
      id: json['id'] ?? '',
      periodName: json['period_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period_name': periodName,
    };
  }
}
