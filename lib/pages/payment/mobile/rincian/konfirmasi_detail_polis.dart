import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  context.read<DnRekap2invBloc>().add(
                    DnToInvByListDnProcessEvent(
                      listDn: selectedDnIds.join(";"),
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
