// untuk dashboard HR/Chiefclass AttendanceSummary {
  final int totalHadir;
  final int totalAlpha;
  final int totalIzin;
  final int totalCuti;

  AttendanceSummary({
    required this.totalHadir,
    required this.totalAlpha,
    required this.totalIzin,
    required this.totalCuti,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalHadir: json['total_hadir'] ?? 0,
      totalAlpha: json['total_alpha'] ?? 0,
      totalIzin: json['total_izin'] ?? 0,
      totalCuti: json['total_cuti'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_hadir': totalHadir,
      'total_alpha': totalAlpha,
      'total_izin': totalIzin,
      'total_cuti': totalCuti,
    };
  }
}
