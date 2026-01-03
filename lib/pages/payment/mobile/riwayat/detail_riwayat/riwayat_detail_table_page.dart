import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    double fontSize16 = getResponsiveFont(context, 16);

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              hPadding * 1.5,
              16,
              hPadding * 1.5,
              8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Detail Pembayaran",
                    style: TextStyle(
                      fontSize: fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: hPadding * 1.5,
              vertical: 10,
            ),
            child: BlocBuilder<Pay1CrudBloc, Pay1CrudState>(
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

                return _buildPay1SummaryFromModel(
                  state.record!,
                  fontSize: fontSize16,
                );
              },
            ),
          ),

          const SizedBox(height: hPadding),

          const Divider(height: 1),

          const SizedBox(height: hPadding),

          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
              ),
              child: RiwayatTableWidget(),
            ),
          ),

          const SizedBox(height: hPadding),

          const Divider(height: 1),

          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget _buildPay1SummaryFromModel(Pay1CrudModel model, {required double fontSize}) {
    final labelStyle = TextStyle(
      fontSize: fontSize,
      color: primaryLightColor.withOpacity(0.75),
      fontWeight: FontWeight.w500,
    );

    final valueStyle = TextStyle(
      fontSize: fontSize,
      color: primaryLightColor,
      fontWeight: FontWeight.w600,
    );

    return Column(
      children: [
        _kvRow(labelStyle, valueStyle, "No Pembayaran:", model.ar1Id),

        const SizedBox(height: hPadding),

        _kvRow(labelStyle, valueStyle, "Tanggal Dibayar:", _dateFmt.format(model.arTgl)),

        const SizedBox(height: hPadding),

        _kvRow(labelStyle, valueStyle, "Jumlah Polis Dibayar:", "${model.sppaCount} Polis"),

        const SizedBox(height: hPadding),

        _kvRow(labelStyle, valueStyle, "Total OS:", _fmtNum(model.totalOs)),
      ],
    );
  }

  Widget _kvRow(TextStyle labelStyle, TextStyle valueStyle, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: labelStyle),
        ),
        const SizedBox(width: hPadding),
        Expanded(
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPay1SummarySkeleton({required double fontSize}) {
    Widget line(double w) => Container(
      height: fontSize,
      width: w,
      decoration: BoxDecoration(
        color: primaryLightColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Column(
      children: [
        Row(children: [Expanded(child: line(140)), line(120)]),
        const SizedBox(height: hPadding),
        Row(children: [Expanded(child: line(160)), line(100)]),
        const SizedBox(height: hPadding),
        Row(children: [Expanded(child: line(190)), line(90)]),
        const SizedBox(height: hPadding),
        Row(children: [Expanded(child: line(90)), line(130)]),
      ],
    );
  }

  void refreshData() {
    pay1CrudBloc.add(Pay1CrudLihatEvent(recordId: widget.ar1Id));
    pay2CariBloc.add(RefreshPay2CariEvent(ar1Id: widget.ar1Id)); // abaikan nanti juga boleh
  }
}
