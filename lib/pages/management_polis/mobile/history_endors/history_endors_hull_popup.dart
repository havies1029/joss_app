import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/polis_endors_history/polis_endors_history_bloc.dart';
import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';
import 'history_endors_popup.dart';

Future<void> showHistoryEndorsHullPopup(
  BuildContext context, {
  required String polis2Id,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => PolisEndorsHistoryBloc(),
      child: HistoryEndorsPopup(
        title: 'History Endorsement Hull',
        polis2Id: polis2Id,
        cob: PolisEndorsHistoryCob.hull,
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
            title: 'NAMA KAPAL',
            valueGetter: (d) => _text(d.namaKapal),
            normalFlex: 2,
            compactMinWidth: 160,
            compactMaxWidth: 260,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'KELAS KAPAL',
            valueGetter: (d) => _text(d.vesselClass),
            normalFlex: 1.7,
            compactMinWidth: 150,
            compactMaxWidth: 230,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'COVERAGE',
            valueGetter: (d) => _text(d.coverage),
            normalFlex: 1.5,
            compactMinWidth: 140,
            compactMaxWidth: 210,
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
            normalFlex: 2.1,
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
