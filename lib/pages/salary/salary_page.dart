import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/salary/salary_history.dart';
import '../../models/salary/salary_slip.dart';
import '../../services/salary_service.dart';
import 'salary_detail.dart';

class SalaryPage extends StatefulWidget {
  final User user;

  const SalaryPage({super.key, required this.user});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  String? _selectedPeriod; // buat HR & Chief
  List<String> _periods = [];
  List<SalarySlip> _slips = [];

  @override
  void initState() {
    super.initState();
    _loadPeriods();
  }

  Future<void> _loadPeriods() async {
    // TODO: ganti ke SalaryService().getPeriods();
    setState(() {
      _periods = [
        "Oktober 2024",
        "November 2024",
        "Desember 2024",
      ];
    });
  }

  Future<void> _loadSlips(String period) async {
    // TODO: ganti ke SalaryService().getSlips(period, role);
    setState(() {
      if (widget.user.isEmployee) {
        _slips = [
          SalarySlip(
            id: "1",
            employeeId: widget.user.id,
            employeeName: widget.user.name,
            period: period,
            pdfUrl: "https://contoh.com/slip-${widget.user.name}.pdf",
          )
        ];
      } else {
        _slips = [
          SalarySlip(
            id: "1",
            employeeId: "e1",
            employeeName: "Karyawan 1",
            period: period,
            pdfUrl: "https://contoh.com/slip-e1.pdf",
          ),
          SalarySlip(
            id: "2",
            employeeId: "e2",
            employeeName: "Karyawan 2",
            period: period,
            pdfUrl: "https://contoh.com/slip-e2.pdf",
          ),
          SalarySlip(
            id: "3",
            employeeId: "e3",
            employeeName: "Karyawan 3",
            period: period,
            pdfUrl: "https://contoh.com/slip-e3.pdf",
          ),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = widget.user.isEmployee;
    final isHR = widget.user.isHR;
    final isChief = widget.user.isChief;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Payroll"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isHR || isChief) ...[
              const Text(
                "Periode Penggajian",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPeriod,
                items: _periods
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                  if (value != null) _loadSlips(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedPeriod != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: _slips.length,
                    itemBuilder: (context, index) {
                      final slip = _slips[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(slip.employeeName),
                        trailing: const Icon(Icons.info_outline),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalaryDetail(slip: slip),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
            if (isEmployee) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _periods.length,
                  itemBuilder: (context, index) {
                    final period = _periods[index];
                    return ListTile(
                      leading: const Icon(Icons.money),
                      title: Text(period),
                      trailing: const Icon(Icons.visibility),
                      onTap: () async {
                        await _loadSlips(period);
                        if (_slips.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalaryDetail(slip: _slips.first),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
