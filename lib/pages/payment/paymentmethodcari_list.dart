import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_event.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodsCariListPage extends StatefulWidget {
  const PaymentMethodsCariListPage({super.key});

  @override
  State<PaymentMethodsCariListPage> createState() => _PaymentMethodsCariListPageState();
}

class _PaymentMethodsCariListPageState extends State<PaymentMethodsCariListPage> {
  @override
  void initState() {
    super.initState();

    // Load data ketika page dibuka
    context.read<PaymentMethodCariBloc>().add(PaymentMethodCariLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.hasError) {
                  return const Center(child: Text("Failed to load data"));
                }

                final list = state.categories;

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final cat = list[index];

                    return ExpansionTile(
                      title: Text(cat.categoryName),
                      children: cat.items.map((item) {
                        return RadioListTile<String>(
                          title: Text(item.title),
                          value: item.methodId,
                          groupValue: state.selectedMethodId,
                          onChanged: (value) {
                            context
                                .read<PaymentMethodCariBloc>()
                                .add(PaymentSelectMethodEvent(value!));
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // =============================
      //  FOOTER BUTTON
      // =============================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              final selected = context.read<PaymentMethodCariBloc>().state.selectedMethodId;

              if (selected == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Silakan pilih metode pembayaran")),
                );
                return;
              }

              context.read<DnRekap2invBloc>().add(Invoice2PaymentViaVAEvent(
                invoiceId: context.read<DnRekap2invBloc>().state.invoiceId, 
                methodId: selected,
              ));

              Navigator.pop(context, selected);
            },
            child: Text("Lanjutkan"),
          ),
        ),
      ),
    );

  }
}
