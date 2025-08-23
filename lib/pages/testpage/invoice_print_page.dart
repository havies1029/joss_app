import 'package:flutter/material.dart';

class InvoicePrintPage extends StatelessWidget {
  const InvoicePrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // back arrow otomatis
        automaticallyImplyLeading: true, // pastikan tidak dimatikan
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text('Invoice Print'),
      ),
      body: Center(
        child: Text(
          "Page Invoice Print",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}