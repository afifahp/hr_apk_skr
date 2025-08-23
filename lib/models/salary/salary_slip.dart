class SalarySlip {
  final String id;             // ID slip gaji, contoh: "slip_123"
  final String employeeId;     // ID karyawan
  final String employeeName;   // Nama karyawan
  final String period;         // Periode gaji, contoh: "Oktober 2024"
  final String pdfUrl;         // Link ke file PDF slip gaji

  SalarySlip({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.period,
    required this.pdfUrl,
  });

  factory SalarySlip.fromJson(Map<String, dynamic> json) {
    return SalarySlip(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      period: json['period'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'period': period,
      'pdf_url': pdfUrl,
    };
  }
}
