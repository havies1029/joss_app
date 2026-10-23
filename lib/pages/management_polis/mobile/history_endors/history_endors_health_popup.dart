import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/polis_endors_history/polis_endors_history_bloc.dart';
import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';
import 'history_endors_popup.dart';

Future<void> showHistoryEndorsHealthPopup(
  BuildContext context, {
  required String polis2Id,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => PolisEndorsHistoryBloc(),
      child: HistoryEndorsPopup(
        title: 'History Endorsement Health',
        polis2Id: polis2Id,
        cob: PolisEndorsHistoryCob.health,
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
            title: 'NAMA',
            valueGetter: (d) => _text(d.nama),
            normalFlex: 2,
            compactMinWidth: 160,
            compactMaxWidth: 260,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'PAKET',
            valueGetter: (d) => _text(d.paketNama),
            normalFlex: 1.8,
            compactMinWidth: 150,
            compactMaxWidth: 250,
          ),
          DetailPolisColumn<PolisEndorsHistoryModel>(
            title: 'NO IDENTITAS',
            valueGetter: (d) => _text(d.idNo),
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
