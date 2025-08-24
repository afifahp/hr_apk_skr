import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
// import '../../models/salary/salary_history.dart';
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
  final SalaryService _service = SalaryService();
  List<SalarySlip> _slips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSlips();
  }

  Future<void> _loadSlips() async {
    final slips = await _service.getSalarySlips(widget.user.id);
    setState(() {
      _slips = slips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slip Gaji")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _slips.isEmpty
              ? const Center(child: Text("Belum ada slip gaji"))
              : ListView.builder(
                  itemCount: _slips.length,
                  itemBuilder: (context, index) {
                    final slip = _slips[index];
                    return Card(
                      child: ListTile(
                        title: Text("Periode: ${slip.period}"),
                        subtitle: Text("Total: ${slip.total}"),
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
    );
  }
}
