import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/salary/salary_slip.dart';

class SalaryDetail extends StatelessWidget {
  final SalarySlip slip;

  const SalaryDetail({super.key, required this.slip});

  @override
  Widget build(BuildContext context) {
    if (slip.pdfUrl.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Slip Gaji - ${slip.period}"),
        ),
        body: const Center(
          child: Text("❌ File slip gaji tidak tersedia"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Slip Gaji - ${slip.period}"),
      ),
      body: SfPdfViewer.network(
        slip.pdfUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
