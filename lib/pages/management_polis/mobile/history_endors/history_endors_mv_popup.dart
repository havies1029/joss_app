import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/polis_endors_history/polis_endors_history_bloc.dart';
import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';
import 'history_endors_popup.dart';

Future<void> showHistoryEndorsMvPopup(
  BuildContext context, {
  required String polis2Id,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => PolisEndorsHistoryBloc(),
      child: HistoryEndorsPopup(
        title: 'History Endorsement MV',
        polis2Id: polis2Id,
        cob: PolisEndorsHistoryCob.mv,
        columns: [
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'NO ENDORSE',
            valueGetter: _endorseNumber,
            normalFlex: 1.8,
            compactMinWidth: 150,
            compactMaxWidth: 220,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'TGL EFEKTIF',
            valueGetter: (d) => _date(d.effectiveDate),
            normalFlex: 1.2,
            compactMinWidth: 110,
            compactMaxWidth: 140,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'NO PLAT',
            valueGetter: (d) => _text(d.polisiNo),
            normalFlex: 1.2,
            compactMinWidth: 110,
            compactMaxWidth: 150,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'KENDARAAN',
            valueGetter: (d) => _joined([d.merk, d.jenisMv, d.modelMv]),
            normalFlex: 2.2,
            compactMinWidth: 190,
            compactMaxWidth: 300,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'NILAI PERTANGGUNGAN',
            valueGetter: (d) => _money(d.curr, d.nilaiPertanggungan),
            normalFlex: 1.7,
            compactMinWidth: 160,
            compactMaxWidth: 220,
            right: true,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'PREMI',
            valueGetter: (d) => _money(d.curr, d.premi),
            normalFlex: 1.4,
            compactMinWidth: 130,
            compactMaxWidth: 190,
            right: true,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'DESKRIPSI',
            valueGetter: (d) => _text(d.deskripsi),
            normalFlex: 2.2,
            compactMinWidth: 180,
            compactMaxWidth: 300,
            expandable: true,
          ),
        ],
      ),
    ),
  );
}

String _endorseNumber(PolisEndorsHistoryModel item) => _text(
      item.endorsNo.isNotEmpty
          ? item.endorsNo
          : item.sppaEndorsNo.isNotEmpty
              ? item.sppaEndorsNo
              : item.endors1Id,
    );

String _date(DateTime? value) =>
    value == null ? '-' : DateFormat('dd-MM-yyyy').format(value);

String _money(String curr, num value) =>
    '${curr.trim()} ${NumberFormat.decimalPattern().format(value)}'.trim();

String _text(String value) => value.trim().isEmpty ? '-' : value.trim();

String _joined(List<String> values) {
  final result = values.where((value) => value.trim().isNotEmpty).join(' - ');
  return result.isEmpty ? '-' : result;
}
