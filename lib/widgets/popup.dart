import 'package:flutter/material.dart';

class Popup {
  /// Popup konfirmasi (contoh: Accept / Decline / Delete)
  static Future<bool?> confirm({
    required BuildContext context,
    String title = "Konfirmasi",
    String message = "Apakah Anda yakin?",
    String confirmText = "Ya",
    String cancelText = "Batal",
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Popup info (misalnya notifikasi berhasil atau gagal)
  static Future<void> info({
    required BuildContext context,
    String title = "Informasi",
    required String message,
    String buttonText = "OK",
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Popup loading (misalnya saat call API lama)
  static void loading(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // user tidak bisa back
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  /// Tutup popup apapun
  static void close(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
