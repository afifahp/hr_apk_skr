class LeaveBalance {
  final int totalCuti;
  final int cutiTerpakai;
  final int sisaCuti;

  LeaveBalance({
    required this.totalCuti,
    required this.cutiTerpakai,
    required this.sisaCuti,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      totalCuti: json["total_cuti"] ?? 0,
      cutiTerpakai: json["cuti_terpakai"] ?? 0,
      sisaCuti: json["sisa_cuti"] ?? 0,
    );
  }
}
