class SalarySlip {   //ini samain sama yg di frappe. tp jujur untuk itung2annya bakal lama banget T_T
  final String id;             // ID slip gaji, contoh: "slip_123"
  final String employeeId;     // ID karyawan
  final String employeeName;   // Nama karyawan
  final String total;   // Nama karyawan
  final String period;         // Periode gaji, contoh: "Oktober 2024"
  final String pdfUrl;         // Link ke file PDF slip gaji

  SalarySlip({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.period,
    required this.total,
    required this.pdfUrl,
  });

  factory SalarySlip.fromJson(Map<String, dynamic> json) {
    return SalarySlip(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      period: json['period'] ?? '',
      total: json['total'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'period': period,
      'total': total,
      'pdf_url': pdfUrl,
    };
  }
}
