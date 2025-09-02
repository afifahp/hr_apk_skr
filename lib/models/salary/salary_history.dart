class SalaryHistory {
  final String name;        // misal "2025-01"
  final String start_date; // misal "Januari 2025"
  final String end_date;   // misal "31 Januari 2025"
  final String company;          // misal "PER-0001"

  SalaryHistory({
    required this.name,
    required this.start_date,
    required this.end_date,
    required this.company,
  });

  factory SalaryHistory.fromJson(Map<String, dynamic> json) {
    return SalaryHistory(
      name: json['name'] ?? '',
      start_date: json['start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_date': start_date,
      'end_date': end_date,
      'company': company,
    };
  }
}
