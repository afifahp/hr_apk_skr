import 'package:flutter/material.dart';

class WfahFormPage extends StatefulWidget {
  const WfahFormPage({super.key});

  @override
  State<WfahFormPage> createState() => _WfahFormPageState();
}

class _WfahFormPageState extends State<WfahFormPage> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Request WFH/A")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal: ${DateTime.now().toLocal()}"),
            const SizedBox(height: 10),

            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Keterangan",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final reason = _reasonController.text.trim();

                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Keterangan wajib diisi")),
                    );
                    return;
                  }

                  // TODO: simpan ke backend (status awal = PENDING)
                  // contoh sementara:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Request berhasil diajukan")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Konfirmasi Permintaan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
