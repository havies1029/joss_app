import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/polis_endors_history/polis_endors_history_bloc.dart';
import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';
import 'history_endors_popup.dart';

Future<void> showHistoryEndorsParPopup(
  BuildContext context, {
  required String polis2Id,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => PolisEndorsHistoryBloc(),
      child: HistoryEndorsPopup(
        title: 'History Endorsement PAR',
        polis2Id: polis2Id,
        cob: PolisEndorsHistoryCob.par,
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
            title: 'LOKASI',
            valueGetter: (d) => _joined([d.lokasi1, d.lokasi2]),
            normalFlex: 2.2,
            compactMinWidth: 180,
            compactMaxWidth: 300,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'OKUPASI',
            valueGetter: (d) => _text(d.okupasiDesc),
            normalFlex: 1.7,
            compactMinWidth: 150,
            compactMaxWidth: 240,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'TSI',
            valueGetter: (d) => _money(d.curr, d.tsi),
            normalFlex: 1.5,
            compactMinWidth: 140,
            compactMaxWidth: 200,
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
