import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_method//payment_list.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../../blocs/payment/paymentmethodcari_state.dart';
import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../invbayarvaform_form.dart';
import '../payment_process/payment_process.dart';

class PaymentMethodPage extends StatefulWidget {
  final String curr;
  final double totalBayar;

  const PaymentMethodPage({
    super.key,
    required this.curr,
    required this.totalBayar,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.hasError) {
                    return const Center(
                        child: Text("Gagal memuat metode pembayaran"));
                  }

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: pGrey,
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                          border: Border.all(color: sGrey)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Pembayaran:",
                                style: inputTextStyle(context),
                              ),
                              Text(
                                "${widget.curr} "
                                    "${NumberFormat("#,###").format(widget.totalBayar)}",
                                style: headingStyle(context),
                              ),
                            ]),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final cat = state.categories[index];

                            return PaymentList(
                              categoryName: cat.categoryName,
                              items: cat.items,
                              isExpanded: _expandedIndex == index,
                              onTapHeader: () {
                                if (_expandedIndex != index) {
                                  context
                                      .read<PaymentMethodCariBloc>()
                                      .add(PaymentResetSelectedEvent());
                                }

                                setState(() {
                                  _expandedIndex =
                                      _expandedIndex == index ? null : index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            /// ===== BUTTON LANJUTKAN =====
            BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
              builder: (context, state) {
                if (state.selectedMethodId == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton.primary(
                    text: "Lanjutkan",
                    onPressed: _onLanjutkanPressed,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLanjutkanPressed() {
    final methodState = context.read<PaymentMethodCariBloc>().state;
    final selectedId = methodState.selectedMethodId;
    if (selectedId == null) return;

    final dnState = context.read<DnRekap2invBloc>().state;

    context.read<DnRekap2invBloc>().add(
          Invoice2PaymentViaVAEvent(
            invoiceId: dnState.invoiceId,
            methodId: selectedId,
          ),
        );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
