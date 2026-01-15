import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/pay2cari_bloc.dart';
import 'package:joss_app/blocs/payment/pay1crud_bloc.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/detail_riwayat/riwayat_table_widget.dart';

import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../models/payment/pay1crud_model.dart';

class RiwayatDetailTablePage extends StatefulWidget {
  final String ar1Id;
  const RiwayatDetailTablePage({super.key, required this.ar1Id});

  @override
  RiwayatDetailTablePageState createState() => RiwayatDetailTablePageState();
}

class RiwayatDetailTablePageState extends State<RiwayatDetailTablePage> {
  late Pay2CariBloc pay2CariBloc;
  late Pay1CrudBloc pay1CrudBloc;

  final _dateFmt = DateFormat('dd MMM yyyy');
  String _fmtNum(num v) => NumberFormat.decimalPattern().format(v);

  @override
  void initState() {
    super.initState();
    pay1CrudBloc = context.read<Pay1CrudBloc>();
    pay2CariBloc = context.read<Pay2CariBloc>();

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
            Row(
              children: [
                const Spacer(),
                Text(
                  "Detail",
                  style: bodyTextStyle(context, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const Divider(height: 1),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<Pay1CrudBloc, Pay1CrudState>(
              buildWhen: (p, c) =>
              p.isLoading != c.isLoading ||
                  p.isLoaded != c.isLoaded ||
                  p.record != c.record,
              builder: (context, state) {
                if (state.isLoading ||
                    state.isLoaded != true ||
                    state.record == null) {
                  return const LoadingIndicator();
                }

                return _buildPay1SummaryFromModel(state.record!);
              },
            ),

            const SizedBox(height: hPadding),
            const Divider(height: 1),
            const SizedBox(height: hPadding),

            SizedBox(
              height: 250,
              child: SingleChildScrollView(
                child: RiwayatTableWidget(),
              ),
            ),


            const SizedBox(height: hPadding),
            const Divider(height: 1),
            const SizedBox(height: hPadding),

            BlocBuilder<Pay1CrudBloc, Pay1CrudState>(
              buildWhen: (p, c) =>
              p.isLoading != c.isLoading ||
                  p.isLoaded != c.isLoaded ||
                  p.record != c.record,
              builder: (context, state) {
                if (state.isLoading ||
                    state.isLoaded != true ||
                    state.record == null) {
                  return const LoadingIndicator();
                }

                return _buildTotalBayar(state.record!);
              },
            ),

            const SizedBox(height: hPadding),

            AppButton.iconLeft(
              text: 'Unduh Invoice',
              backgroundColor: primaryColor,
              icon: SvgPicture.asset(
                'assets/icons/invoice.svg',
                width: 18,
                height: 18,
              ),
            ),
          ],
        ),
      )
      ],
        ),
      )
    );
  }

  Widget _buildPay1SummaryFromModel(Pay1CrudModel model) {
    final title = bodyTextStyle(context, fontSize: 14);
    final value =
    bodyTextStyle(context, fontSize: 14).copyWith(color: hintGrey);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("No Pembayaran:", style: title),
            Text(model.ar1Id, style: value),
          ],
        ),
        const SizedBox(height: hPadding),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tanggal Dibayar:", style: title),
            Text(_dateFmt.format(model.arTgl), style: value),
          ],
        ),
        const SizedBox(height: hPadding),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Jumlah Polis Dibayar:", style: title),
            Text("${model.sppaCount} Polis", style: value),
          ],
        ),
      ],
    );
  }


  Widget _buildTotalBayar(Pay1CrudModel model) {
    final title = bodyTextStyle(context, fontSize: 14);
    final value =
    bodyTextStyle(context, fontSize: 14).copyWith(color: hintGrey);

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Pembayaran:", style: title),
        Text(_fmtNum(model.totalOs), style: value),
      ],
    );
  }

  // Widget _kvRow(TextStyle labelStyle, TextStyle valueStyle, String label, String value) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Text(label, style: labelStyle),
  //       ),
  //       const SizedBox(width: hPadding),
  //       Expanded(
  //         child: Text(
  //           value,
  //           style: valueStyle,
  //           textAlign: TextAlign.right,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildPay1SummarySkeleton({required double fontSize}) {
  //   Widget line(double w) => Container(
  //     height: fontSize,
  //     width: w,
  //     decoration: BoxDecoration(
  //       color: primaryLightColor.withOpacity(0.12),
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //   );
  //
  //   return Column(
  //     children: [
  //       Row(children: [Expanded(child: line(140)), line(120)]),
  //       const SizedBox(height: hPadding),
  //       Row(children: [Expanded(child: line(160)), line(100)]),
  //       const SizedBox(height: hPadding),
  //       Row(children: [Expanded(child: line(190)), line(90)]),
  //       const SizedBox(height: hPadding),
  //       Row(children: [Expanded(child: line(90)), line(130)]),
  //     ],
  //   );
  // }

  void refreshData() {
    pay1CrudBloc.add(Pay1CrudLihatEvent(recordId: widget.ar1Id));
    pay2CariBloc.add(RefreshPay2CariEvent(ar1Id: widget.ar1Id)); // abaikan nanti juga boleh
  }
}
