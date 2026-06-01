import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/klaimringkas/klaimringkascari_model.dart';
import 'package:joss_app/pages/management_polis/mobile/cob_polis/template_polis_table/cob_policy_table.dart';

class KlaimRingkasanTableWidget extends StatefulWidget {
  const KlaimRingkasanTableWidget({super.key});

  @override
  KlaimRingkasanTableWidgetState createState() =>
      KlaimRingkasanTableWidgetState();
}

class KlaimRingkasanTableWidgetState extends State<KlaimRingkasanTableWidget> {
  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KlaimringkasCariBloc, KlaimringkasCariState>(
      buildWhen: (previous, current) {
        return current.status == ListStatus.success;
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status != ListStatus.success || state.items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 720,
            ),
            child: CobPolicyTable<KlaimringkasCariModel>(
              items: state.items,
              selectedIds: const [],
              enablePagination: false,
              enableSelection: false,
              enableDetailTap: false,
              filterSelectedWhenReadOnly: false,
              readOnly: true,
              idGetter: (d) => d.nourut.toString(),
              nomorGetter: (d, index) => d.nourut.toString(),
              onSelect: (_) {},
              onUnselect: (_) {},
              onOpenDetail: (_, __) {},
              columns: [
                CobPolicyColumn<KlaimringkasCariModel>(
                  title: "KATEGORI",
                  valueGetter: (d) => d.cobNama,
                  normalFlex: 2.3,
                  compactWidth: 160,
                  normalMaxLines: 1,
                  compactMaxLines: 2,
                ),
                CobPolicyColumn<KlaimringkasCariModel>(
                  title: "JUMLAH KLAIM",
                  valueGetter: (d) => formatNum(d.klaimQty),
                  normalFlex: 1.4,
                  compactWidth: 120,
                  normalSoftWrap: false,
                  compactSoftWrap: false,
                ),
                CobPolicyColumn<KlaimringkasCariModel>(
                  title: "TOTAL NILAI",
                  valueGetter: (d) =>
                  "${d.currNama} ${formatNum(d.klaimAmount)}",
                  normalFlex: 2.2,
                  compactWidth: 200,
                  normalSoftWrap: false,
                  compactSoftWrap: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}