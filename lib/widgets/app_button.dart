import 'package:flutter/material.dart';

enum ButtonType {
  login,
  simpan,
  konfirmasi,
  checkIn,
  checkOut,
  accept,
  decline,
  selesai,
  pengajuan,
  print,
}

class AppButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(type);

    return ElevatedButton.icon(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config['color'] as Color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
      icon: config['icon'] as Icon,
      label: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(config['label'] as String),
    );
  }

  Map<String, dynamic> _getConfig(ButtonType type) {
    switch (type) {
      case ButtonType.login:
        return {
          "label": "Login",
          "color": Colors.blue,
          "icon": const Icon(Icons.login),
        };
      case ButtonType.simpan:
        return {
          "label": "Simpan",
          "color": Colors.green,
          "icon": const Icon(Icons.save),
        };
      case ButtonType.konfirmasi:
        return {
          "label": "Konfirmasi",
          "color": Colors.orange,
          "icon": const Icon(Icons.check_circle),
        };
      case ButtonType.checkIn:
        return {
          "label": "Check-In",
          "color": Colors.blue,
          "icon": const Icon(Icons.login),
        };
      case ButtonType.checkOut:
        return {
          "label": "Check-Out",
          "color": Colors.red,
          "icon": const Icon(Icons.logout),
        };
      case ButtonType.accept:
        return {
          "label": "Terima",
          "color": Colors.green,
          "icon": const Icon(Icons.check),
        };
      case ButtonType.decline:
        return {
          "label": "Tolak",
          "color": Colors.red,
          "icon": const Icon(Icons.close),
        };
      case ButtonType.selesai:
        return {
          "label": "Selesai",
          "color": Colors.grey,
          "icon": const Icon(Icons.done_all),
        };
      case ButtonType.pengajuan:
        return {
          "label": "Pengajuan",
          "color": Colors.blueGrey,
          "icon": const Icon(Icons.assignment),
        };
      case ButtonType.print:
        return {
          "label": "Cetak",
          "color": Colors.indigo,
          "icon": const Icon(Icons.print),
        };
    }
  }
}
