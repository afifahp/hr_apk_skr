import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/salary/salary_slip.dart';
import '../../models/salary/salary_history.dart';
import '../../services/salary_service.dart';
import 'salary_detail.dart';

class SalaryPage extends StatefulWidget {
  final User user;

  const SalaryPage({super.key, required this.user});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  bool _isLoading = true;
  List<SalaryHistory> _periods = [];
  List<SalarySlip> _slips = [];
  String? _selectedPeriod;

  @override
  void initState() {
    super.initState();

    if (widget.user.isEmployee) {
      // 🔹 Karyawan langsung load slip miliknya
      _loadEmployeeSlips();
    } else {
      // 🔹 HR / CFO / Chief lain harus pilih periode dulu
      _loadPeriods();
    }
  }

  /// 🔹 Employee: ambil slip milik sendiri
  Future<void> _loadEmployeeSlips() async {
    setState(() => _isLoading = true);
    try {
      final slips = await SalaryService.getSalarySlips(
        periodId: "", // backend bisa abaikan kalau ada employeeId
        // employeeId: widget.user.id,
      );
      setState(() {
        _slips = slips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error load slip: $e")),
      );
    }
  }

  /// 🔹 HR / CFO / Chief Officer → ambil daftar periode
  Future<void> _loadPeriods() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final periods = await SalaryService.getSalaryHistory();

    setState(() {
      _periods = periods;

      // default pilih periode terbaru
      if (periods.isNotEmpty) {
        _selectedPeriod = periods.first.name;
      }
      _isLoading = false;
    });

    // kalau ada periode terpilih, load slip sesuai periode itu
    if (_selectedPeriod != null) {
      await _loadSlips(_selectedPeriod!);
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("⚠️ Error load periode: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  /// 🔹 Load slip sesuai role
  Future<void> _loadSlips(String periodId) async {
    setState(() => _isLoading = true);
    try {
      List<SalarySlip> slips = [];

      if (widget.user.isHR || widget.user.isCFO) {
        // 🔹 HR & CFO: lihat semua slip
        slips = await SalaryService.getSalarySlips(periodId: periodId);
      } else if (widget.user.isOtherChief) {
        // 🔹 Chief lain: lihat slip divisi mereka
        slips = await SalaryService.getSalarySlips(
          periodId: periodId,
          divisionId: widget.user.subRole, // asumsi subRole = kode divisi
        );
      }

      setState(() {
        _slips = slips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error load slip: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slip Gaji")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔹 Dropdown hanya untuk HR & Chief
                if (!widget.user.isEmployee && _periods.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedPeriod,
                      items: _periods.map((p) {
                        return DropdownMenuItem(
                          value: p.name,
                          child: Text(p.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedPeriod = val);
                          _loadSlips(val);
                        }
                      },
                    ),
                  ),

                // 🔹 List slip gaji
                Expanded(
                  child: _slips.isEmpty
                      ? const Center(child: Text("Tidak ada data slip gaji"))
                      : ListView.builder(
                          itemCount: _slips.length,
                          itemBuilder: (context, index) {
                            final slip = _slips[index];
                            return Card(
                              child: ListTile(
                                title: Text("Periode: ${slip.name}"),
                                subtitle: Text("Total: ${slip.net_pay}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SalaryDetail(slip: slip),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
