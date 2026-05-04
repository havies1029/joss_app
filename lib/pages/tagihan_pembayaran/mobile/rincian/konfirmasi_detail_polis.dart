  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
  import '../../../../common/constants.dart';
  import '../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../base/base_background_sidepage.dart';
  import 'rincian_tabel_page.dart';

  //micky 2026-02-27

  class RincianKonfirmasiDetailPage extends StatelessWidget {
    final List<String> selectedDnIds;

    const RincianKonfirmasiDetailPage({
      super.key,
      required this.selectedDnIds,
    });

    String _resolveCurrFromRincian(DnRekap2invState state, List<String> selectedDnIds) {
      final selectedDetails = state.rincianSOA.headers
          .expand((h) => h.details)
          .where((d) => selectedDnIds.contains(d.dn1Id))
          .toList();

      if (selectedDetails.isEmpty) return "";

      final uniqueCurr = selectedDetails.map((e) => e.currSimbol).where((c) => c.isNotEmpty).toSet();
      if (uniqueCurr.isEmpty) return "";

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

                    // context.read<DnRekap2invBloc>().add(
                    //   DnToInvByListDnProcessEvent(
                    //     listDn: selectedDnIds.join(";"),
                    //     curr: curr.isEmpty ? null : curr,
                    //   ),
                    // );
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      builder: (dialogContext) => RegisterClientPopUp(
                        header: 'Fitur pembayaran belum tersedia.',
                        showIcon: false,
                        description:
                        'Saat ini aplikasi masih dalam mode Demo/Uji Coba. Pembayaran belum dapat dilakukan. Silahkan tunggu hingga aplikasi Go Live.',
                        buttonText: 'Mengerti',
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
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
