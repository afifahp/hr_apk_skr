class AttendanceOverview {
  final int hadir;
  final int izin;
  final int sakit;
  final int alfa;

  AttendanceOverview({
    required this.hadir,
    required this.izin,
    required this.sakit,
    required this.alfa,
  });

  factory AttendanceOverview.fromJson(Map<String, dynamic> json) {
    return AttendanceOverview(
      hadir: json["hadir"] ?? 0,
      izin: json["izin"] ?? 0,
      sakit: json["sakit"] ?? 0,
      alfa: json["alfa"] ?? 0,
    );
  }

  /// Untuk keperluan chart
  List<Map<String, dynamic>> toChartData() {
    return [
      {"label": "Hadir", "value": hadir},
      {"label": "Izin", "value": izin},
      {"label": "Sakit", "value": sakit},
      {"label": "Alfa", "value": alfa},
    ];
  }
}
