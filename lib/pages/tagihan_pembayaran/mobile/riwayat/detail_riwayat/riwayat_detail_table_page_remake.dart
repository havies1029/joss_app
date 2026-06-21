import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/historybayar2cari_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
// import 'package:joss_app/pages/payment/mobile/riwayat/detail_riwayat/riwayat_table_widget_remake.dart';


import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../helper/pdf_open_helper.dart';
import '../../../../../models/payment/historybayarcari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import 'riwayat_table_widget_remake.dart';

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                        color: primaryLightColor,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: hPadding,
                ),
                child: BlocConsumer<HistorybayarCariBloc, HistorybayarCariState>(
                  buildWhen: (p, c) =>
                  p.selectedItem != c.selectedItem ||
                      p.isDownloading != c.isDownloading,
                  listenWhen: (prev, curr) =>
                  prev.downloadPath != curr.downloadPath &&
                      curr.downloadPath.isNotEmpty &&
                      !curr.isDownloading,
                  listener: (context, state) async {
                    try {
                      await PdfOpenHelper().openBase64Pdf(
                        base64Pdf: state.downloadPath,
                      );
                    } catch (e) {
                      debugPrint('Gagal buka PDF: $e');
                    }
                  },
                  builder: (context, state) {
                    final selected = state.selectedItem;
                    if (selected == null) return const LoadingIndicator();

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildPay1SummaryFromModel(selected),

                              const SizedBox(height: hPadding),
                              const Divider(height: 1),
                              const SizedBox(height: hPadding),

                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: 120,
                                  maxHeight: 300,
                                ),
                                child: RiwayatTableWidgetRemake(),
                              ),

                              const SizedBox(height: hPadding),
                              const Divider(height: 1),
                              const SizedBox(height: hPadding),

                              _buildTotalBayar(selected),

                              const SizedBox(height: hPadding),

                              Align(
                                alignment: Alignment.centerRight,
                                child: selected.stsInvId == '10002'
                                    ? Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.end,
                                  children: [
                                    AppButton.iconLeft(
                                      text: 'Batal Pembayaran',
                                      backgroundColor: redPayment,
                                      icon: SvgPicture.asset(
                                        'assets/icons/gg_trash.svg',
                                        width: 18,
                                        height: 18,
                                      ),
                                      onPressed: () {
                                        // TODO: tambahkan event batal pembayaran di sini
                                      },
                                    ),

                                    AppButton.iconLeft(
                                      text: 'Lanjut Pembayaran',
                                      backgroundColor: primaryColor,
                                      icon: SvgPicture.asset(
                                        'assets/icons/unduh_invoice.svg',
                                        width: 18,
                                        height: 18,
                                      ),
                                      onPressed: () {
                                        context.read<DnRekap2invBloc>().add(
                                          SetPaymentSummaryEvent(
                                            curr: '', // isi kalau ada currency
                                            totalBayar: selected.totalBayar,
                                          ),
                                        );

                                        context.read<DnRekap2invBloc>().add(
                                          CheckInvoiceStatusEvent(invoiceId: selected.inv1Id),
                                          // SetPaymentSummaryEvent(curr: state.)
                                        );

                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: true,
                                        //   barrierColor: Colors.black.withOpacity(0.6),
                                        //   builder: (dialogContext) => RegisterClientPopUp(
                                        //     showIcon: false,
                                        //     header: 'Fitur pembayaran belum tersedia.',
                                        //     description:
                                        //     'Saat ini aplikasi masih dalam mode Demo/Uji Coba. Pembayaran belum dapat dilakukan. Silahkan tunggu hingga aplikasi Go Live.',
                                        //     buttonText: 'Mengerti',
                                        //     onPressed: () {
                                        //       Navigator.of(dialogContext).pop();
                                        //     },
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                )
                                    : AppButton.iconLeft(
                                  text: 'Unduh Invoice',
                                  backgroundColor: greenforPayment,
                                  icon: SvgPicture.asset(
                                    'assets/icons/invoice.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                                  onPressed: () {
                                    context.read<HistorybayarCariBloc>().add(
                                      DownloadInvoiceEvent(
                                        noInv: selected.inv1Id,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (state.isDownloading)
                          Positioned.fill(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: Container(
                                color: Colors.black45,
                                alignment: Alignment.center,
                                child: const LoadingIndicator(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
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
