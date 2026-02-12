import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/historybayar2cari_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/detail_riwayat/riwayat_table_widget_remake.dart';


import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../models/payment/historybayarcari_model.dart';

class RiwayatDetailTablePageRemake extends StatefulWidget {
  final String inv1Id;
  const RiwayatDetailTablePageRemake({super.key, required this.inv1Id});

  @override
  RiwayatDetailTablePageRemakeState createState() => RiwayatDetailTablePageRemakeState();
}

class RiwayatDetailTablePageRemakeState extends State<RiwayatDetailTablePageRemake> {
  late Historybayar2CariBloc historybayar2cariBloc;
  late HistorybayarCariBloc historybayarCariBloc;

  final _dateFmt = DateFormat('dd MMM yyyy');
  String _fmtNum(num v) => NumberFormat.decimalPattern().format(v);

  @override
  void initState() {
    super.initState();
    historybayarCariBloc = context.read<HistorybayarCariBloc>();
    historybayar2cariBloc = context.read<Historybayar2CariBloc>();

    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: sGrey),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "Detail",
                      style: bodyTextStyle(
                        context,
                        fontSize: getResponsiveFont(context, 16),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
                vertical: hPadding,
              ),
              child: BlocBuilder<HistorybayarCariBloc, HistorybayarCariState>(
                buildWhen: (p, c) => p.selectedItem != c.selectedItem,
                builder: (context, state) {
                  final selected = state.selectedItem;
                  if (selected == null) return const LoadingIndicator();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPay1SummaryFromModel(selected),

                      const SizedBox(height: hPadding),
                      const Divider(height: 1),
                      const SizedBox(height: hPadding),

                      SingleChildScrollView(
                        child: RiwayatTableWidgetRemake(),
                      ),

                      const SizedBox(height: hPadding),
                      const Divider(height: 1),
                      const SizedBox(height: hPadding),

                      _buildTotalBayar(selected),

                      const SizedBox(height: hPadding),

                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Align(
                      //         alignment: Alignment.centerLeft,
                      //         child: AppButton.iconLeft(
                      //           text: 'Unduh Polis',
                      //           backgroundColor: primaryColor,
                      //           icon: SvgPicture.asset(
                      //             'assets/icons/invoice.svg',
                      //             width: 18,
                      //             height: 18,
                      //           ),
                      //           onPressed: () {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               const SnackBar(
                      //                 content: Text('Fitur unduh invoice belum tersedia'),
                      //                 duration: Duration(seconds: 2),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Expanded(
                      //       child: Align(
                      //         alignment: Alignment.centerRight,
                      //         child: AppButton.iconLeft(
                      //           text: 'Unduh Invoice',
                      //           backgroundColor: GreenforPayment,
                      //           icon: SvgPicture.asset(
                      //             'assets/icons/unduh_invoice.svg',
                      //             width: 18,
                      //             height: 18,
                      //           ),
                      //           onPressed: () {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               const SnackBar(
                      //                 content: Text('Fitur unduh invoice belum tersedia'),
                      //                 duration: Duration(seconds: 2),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton.iconLeft(
                          text: selected.stsInvId == '10002'
                              ? 'Lanjut Pembayaran'
                              : 'Unduh Invoice',
                          backgroundColor: selected.stsInvId == '10002'
                              ? primaryColor
                              : GreenforPayment,
                          icon: SvgPicture.asset(
                            selected.stsInvId == '10002'
                                ? 'assets/icons/unduh_invoice.svg'
                                : 'assets/icons/invoice.svg',
                            width: 18,
                            height: 18,
                          ),
                          onPressed: () {
                            if (selected.stsInvId == '10002') {
                              // lanjut pembayaran
                              context.read<DnRekap2invBloc>().add(
                                CheckInvoiceStatusEvent(invoiceId: selected.inv1Id),
                              );
                            } else {
                              // unduh invoice
                              context.read<HistorybayarCariBloc>().add(
                                DownloadInvoiceEvent(
                                  noInv: selected.inv1Id,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPay1SummaryFromModel(HistorybayarCariModel model) {
    final title = bodyTextStyle(context, fontSize: 14);
    final value =
    bodyTextStyle(context, fontSize: 14).copyWith(color: hintGrey);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("No Pembayaran:", style: title),
            Text(model.inv1Id, style: value),
          ],
        ),
        const SizedBox(height: hPadding),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tanggal Dibayar:", style: title),
            Text(_dateFmt.format(model.invTgl), style: value),
          ],
        ),
        const SizedBox(height: hPadding),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Jumlah Polis Dibayar:", style: title),
            Text("${model.jmlPolis} Polis", style: value),
          ],
        ),
      ],
    );
  }


  Widget _buildTotalBayar(HistorybayarCariModel model) {
    final title = bodyTextStyle(context, fontSize: 14);
    final value =
    bodyTextStyle(context, fontSize: 14).copyWith(color: hintGrey);

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Pembayaran:", style: title),
        Text(_fmtNum(model.totalBayar), style: value),
      ],
    );
  }

  void refreshData() {
    // historybayarCariBloc.add(RefreshHistorybayarCariEvent(statusId: widget.inv1Id, searchText: ''));
    historybayar2cariBloc.add(RefreshHistorybayar2CariEvent(inv1Id: widget.inv1Id));
  }
}
