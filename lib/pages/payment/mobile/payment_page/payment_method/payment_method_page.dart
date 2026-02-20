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
  final categoryIcons = [
    'assets/icons/va.svg',
    'assets/icons/ewallet.svg',
    'assets/icons/cc.svg',
  ];

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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Total Pembayaran:", style: inputTextStyle(context)),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.curr} ${NumberFormat("#,###").format(widget.totalBayar)}",
                              style: headingStyle(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: pGrey,
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                          border: Border.all(color: sGrey),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: state.categories.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: sGrey.withOpacity(0.5),
                          ),
                          itemBuilder: (context, index) {
                            final cat = state.categories[index];

                            return PaymentList(
                              iconPath: categoryIcons[index],
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
            BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
              builder: (context, state) {
                if (state.selectedMethodId == null) {
                  return const SizedBox.shrink();
                }

                return AppButton.primary(
                  text: "Lanjutkan",
                  onPressed: _onLanjutkanPressed,
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
