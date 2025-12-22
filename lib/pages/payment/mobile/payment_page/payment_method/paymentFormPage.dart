import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_method//paymentlist.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../../blocs/payment/paymentmethodcari_state.dart';
import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../invbayarvaform_form.dart';
import '../payment_process/payment_process.dart';

class PaymentMethodsCariListPage extends StatefulWidget {
  const PaymentMethodsCariListPage({super.key});

  @override
  State<PaymentMethodsCariListPage> createState() =>
      _PaymentMethodsCariListPageState();
}
class _PaymentMethodsCariListPageState
    extends State<PaymentMethodsCariListPage> {

  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodCariBloc>().add(
      PaymentMethodCariLoadEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Metode Pembayaran",
      child: Container(
        color: secondaryBlackColor,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                builder: (context, state) {
                  if (state.isLoading) return const Center(child: CircularProgressIndicator());
                  if (state.hasError) return const Center(child: Text("Failed to load data"));

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final cat = state.categories[index];
                      return PaymentCategoryTile(
                        categoryName: cat.categoryName,
                        items: cat.items,
                        isExpanded: _expandedIndex == index,
                        onTapHeader: () {
                          context.read<PaymentMethodCariBloc>().add(PaymentResetSelectedEvent());

                          setState(() {
                            _expandedIndex = _expandedIndex == index ? null : index;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),

            BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
              builder: (context, state) {
                if (state.selectedMethodId == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton.primary(
                    text: "Lanjutkan",
                    onPressed: onLanjutkanPressed,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void onLanjutkanPressed() {
    final methodState = context.read<PaymentMethodCariBloc>().state;
    final selectedId = methodState.selectedMethodId;
    if (selectedId == null) return;

    final dnState = context.read<DnRekap2invBloc>().state;
    final invoiceId = dnState.invoiceId;

    context.read<DnRekap2invBloc>().add(
      Invoice2PaymentViaVAEvent(
        invoiceId: invoiceId,
        methodId: selectedId,
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
