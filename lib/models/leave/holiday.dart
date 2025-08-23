class Holiday {
  final String name;
  final DateTime date;

  Holiday({
    required this.name,
    required this.date,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json["name"] ?? "-",
      date: DateTime.parse(json["date"]),
    );
  }
}
