import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_grand_total_widget.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_tabel_page.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../common/constants.dart';
import '../../../base/base_background_sidepage.dart';

class RincianKonfirmasiDetailPage extends StatelessWidget {
  final List<String> selectedDnIds;

  const RincianKonfirmasiDetailPage({
    super.key,
    required this.selectedDnIds,
  });

  String _resolveCurrFromRincian(DnRekap2invState state, List<String> selectedDnIds) {
    final selectedDetails = state.rincianSOA.headers
        .expand((h) => h.details) // List<DnDetailSppaModel>
        .where((d) => selectedDnIds.contains(d.dn1Id))
        .toList();

    if (selectedDetails.isEmpty) return "";

    final uniqueCurr = selectedDetails.map((e) => e.currSimbol).where((c) => c.isNotEmpty).toSet();
    if (uniqueCurr.isEmpty) return "";

    // Kalau ternyata ada banyak currency, kamu bisa pilih salah satu atau lempar error.
    // Aku saranin: kalau >1, jangan lanjut.
    // if (uniqueCurr.length > 1) return "__MIXED__";

    return uniqueCurr.first;
  }


  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Konfirmasi Detail Polis',
      child: Container(
        color: secondaryBlackColor,
        child: Column(
          children: [
            Expanded(
              child: RincianTablePage(
                headers: context.read<DnRekap2invBloc>()
                    .state
                    .rincianSOA
                    .headers,
                selectedIds: selectedDnIds,
                onSelect: (_) {},
                onUnselect: (_) {},
                readOnly: true,
                showFooter: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: AppButton.primary(
                text: "Lanjut Pembayaran",
                onPressed: () {
                  final dnBloc = context.read<DnRekap2invBloc>();
                  final curr = _resolveCurrFromRincian(dnBloc.state, selectedDnIds);
                  //
                  // if (curr == "__MIXED__") {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     errorSnackBar("Currency berbeda-beda, tidak bisa digabung"),
                  //   );
                  //   return;
                  // }

                  context.read<DnRekap2invBloc>().add(
                    DnToInvByListDnProcessEvent(
                      listDn: selectedDnIds.join(";"),
                      curr: curr.isEmpty ? null : curr,
                    ),
                  );
                },

              ),
            )
          ],
        ),
      )
    );
  }
}
