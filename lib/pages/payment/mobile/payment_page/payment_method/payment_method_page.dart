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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.hasError) {
                      return const Center(
                        child: Text("Gagal memuat metode pembayaran"),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: pGrey,
                            borderRadius: BorderRadius.circular(cardBorderRadius),
                            border: Border.all(color: sGrey),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
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
                            ],
                          ),
                        ),

                        SizedBox(height: vPadding),

                        Expanded(
                          child: ListView.builder(
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final cat = state.categories[index];

                              return Padding(
                                padding: EdgeInsets.only(bottom: hPadding),
                                child: PaymentList(
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
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            /// ===== BUTTON LANJUTKAN =====
            BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
              builder: (context, state) {
                if (state.selectedMethodId == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPadding * 1.5,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton.primary(
                      text: "Lanjutkan",
                      onPressed: _onLanjutkanPressed,
                    ),
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
