import 'package:flutter/material.dart';
import 'package:joss_app/pages/testpage/invoice_print_page.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // back arrow otomatis
        automaticallyImplyLeading: true, // pastikan tidak dimatikan
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text('Invoice'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            // Aksi ketika button ditekan
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const InvoicePrintPage()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // warna teks
            backgroundColor: Colors.blue,  // warna background
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Print Invoice",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}