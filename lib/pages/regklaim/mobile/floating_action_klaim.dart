
import 'package:flutter/material.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/daftar_cob_klaim_page.dart';
import '../../klaimbatal/mobile/klaimbatalcrud_form.dart';
import '../../klaimlacak/mobile/klaimprogresscari_main.dart';
import '../../perbaruiklaimmv/mobile/perbaruiklaimmv_page.dart';
import '../../perbaruiklaimmv/mobile/perbaruiklaimmv_page_remake.dart';
import '../../perbaruiklaimpar/mobile/perbaruiklaimpar_page.dart';

class FabActionKlaim extends StatelessWidget {
  final int selectedTab;

  const FabActionKlaim({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupcobCariBloc, GroupcobCariState>(
      builder: (context, state) {
        debugPrint("Selected ID: ${state.selectedId}");
        bool isBerjalan = false;
        bool isLacak = false;
        String selectedId = "";
        KlaimdetailCariModel? selected;
        if (selectedTab == 1) {
          selectedId = state.selectedId;
          selected = selectedId.isNotEmpty
              ? state.items
              .expand((group) => group.details)
              .where((d) => d.klaim1Id == selectedId)
              .firstOrNull
              : null;
          final status = (selected?.statusDesc ?? '').toLowerCase().trim();

          isBerjalan = status == "berjalan";
          // isLacak = true;
          isLacak = selected != null;
        }
       
        final actions = [
          ActionMenuItem(
            type: ActionType.klaimBaru,
            label: "Klaim Baru",
            iconAsset: "assets/icons/Plus Icon.svg",
            gradientColors: const [Color(0xFF2ECC71), Color(0xFF2F9F22)],
            borderColor: const Color(0xFF99FF98),
            isEnabled: true,
          ),
          ActionMenuItem(
            type: ActionType.perbaruiKlaim,
            label: "Perbarui Klaim",
            iconAsset: "assets/icons/aktifkan_kembali.svg",
            gradientColors: const [Color(0xFFFFEB39), Color(0xFFAC8C0A)],
            borderColor: const Color(0xFFFFDB78),
            isEnabled: isBerjalan,
          ),
          ActionMenuItem(
            type: ActionType.lacakKlaim,
            label: "Lacak Klaim",
            iconAsset: "assets/icons/lacak_polis.svg",
            gradientColors: const [Color(0xFF48E0FF), Color(0xFF02B1D5)],
            borderColor: const Color(0xFF78E8FF),
            isEnabled: isLacak,
          ),
          ActionMenuItem(
            type: ActionType.batalKlaim,
            label: "Batal Klaim",
            iconAsset: "assets/icons/close.svg",
            gradientColors: const [Color(0xFFFF484B), Color(0xFFC30003)],
            borderColor: const Color(0xFFFF787A),
            isEnabled: isBerjalan,
          ),
        ];

        return FloatingActionMenuWidget(
          availableActions: actions,
          selectedItems: const [],
          onActionTap: (type, _) {
            if (selected == null) {
              if (type == ActionType.klaimBaru) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pilih data terlebih dahulu")),
                );
              }
              return;
            }
        
            switch (type) {
              case ActionType.perbaruiKlaim:
                Navigator.push(context, MaterialPageRoute(builder: (_) =>
                selected!.cobId == "10002"
                    ? PerbaruiKlaimMvPageRemake(klaim1Id: selected.klaim1Id, cobGroupNama: selected.cobNama)
                    : PerbaruiKlaimParPage(klaim1Id: selected.klaim1Id, cobGroupNama: selected.cobNama, cobGroupId: selected.cobId),
                ));
              case ActionType.lacakKlaim:
                Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    KlaimProgressCariMainPage(klaim1Id: selected!.klaim1Id)));
              case ActionType.batalKlaim:
                Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    KlaimbatalcrudFormPage(klaim1Id: selected!.klaim1Id)));
              case ActionType.klaimBaru:
                Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()));
              default:
                break;
            }
          },
        );
      },
    );
  }
}