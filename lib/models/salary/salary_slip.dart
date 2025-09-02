class SalarySlip {   //ini samain sama yg di frappe. tp jujur untuk itung2annya bakal lama banget T_T
  final String name;             // ID slip gaji, contoh: "slip_123"
  final String employee;     // ID karyawan
  final String employee_name; 
  final String start_date;
  final String end_date;  // Nama karyawan
  final String net_pay;   // Nama karyawan
  final String pdfUrl;         // Link ke file PDF slip gaji

  SalarySlip({
    required this.name,
    required this.employee,
    required this.employee_name,
    required this.start_date,
    required this.end_date,
    required this.net_pay,
    required this.pdfUrl,
  });

  factory SalarySlip.fromJson(Map<String, dynamic> json) {
    return SalarySlip(
      name: json['name'] ?? '',
      employee: json['employee_id'] ?? '',
      employee_name: json['employee_name'] ?? '',
      start_date: json['start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      net_pay: json['total'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employee_id': employee,
      'employee_name': employee_name,
      'start_date': start_date,
      'end_date': end_date,
      'total': net_pay,
      'pdf_url': pdfUrl,
    };
  }
}
