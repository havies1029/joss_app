import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsuccessFormPage extends StatelessWidget {
  const PaymentsuccessFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Your payment was successful!'),
            ElevatedButton(
              onPressed: () {
                context.read<DnRekap2invBloc>().add(InitializeDnRekap2invEvent());
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),        
      ),
    );
  } 

}