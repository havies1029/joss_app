import 'package:flutter/material.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/daftar_cob_klaim_page.dart';

// import '../../klaimlacak/klaimprogresscari_main.dart';
import '../../klaimlacak/mobile/klaimprogresscari_main.dart';
import '../../perbaruiklaimmv/mobile/perbaruiklaimmv_page.dart';
import '../../perbaruiklaimpar/mobile/perbaruiklaimpar_page.dart';
// import 'package:joss_app/pages/perbaruiklaimmv/perbaruiklaimmv_page.dart';
// import 'package:joss_app/pages/perbaruiklaimpar/perbaruiklaimpar_page.dart';

class FabActionKlaim extends StatelessWidget {
  final int selectedTab;

  const FabActionKlaim({
    super.key,
    required this.selectedTab,
  });

  List<ActionMenuItem> _allActions() {
    return [
      ActionMenuItem(
        type: ActionType.klaimBaru,
        label: "Klaim Baru",
        iconAsset: "assets/icons/plus icon.svg",
        gradientColors: const [
          Color(0xFF2ECC71),
          Color(0xFF2F9F22),
        ],
        borderColor: const Color(0xFF99FF98),
      ),
      ActionMenuItem(
        type: ActionType.perbaruiKlaim,
        label: "Perbarui Klaim",
        iconAsset: "assets/icons/aktifkan_kembali.svg",
        gradientColors: const [
          Color(0xFFFFEB39),
          Color(0xFFAC8C0A),
        ],
        borderColor: const Color(0xFFFFDB78),
      ),
      ActionMenuItem(
        type: ActionType.lacakKlaim,
        label: "Lacak Klaim",
        iconAsset: "assets/icons/lacak_polis.svg",
        gradientColors: const [
          Color(0xFF48E0FF),
          Color(0xFF02B1D5),
        ],
        borderColor: const Color(0xFF78E8FF),
      ),
      ActionMenuItem(
        type: ActionType.batalKlaim,
        label: "Batal Klaim",
        iconAsset: "assets/icons/close.svg",
        gradientColors: const [
          Color(0xFFFF484B),
          Color(0xFFC30003),
        ],
        borderColor: const Color(0xFFFF787A),
      ),
    ];
  }

  List<ActionMenuItem> _computeActions() {
    final all = _allActions();

    if (selectedTab == 1) {
      return all;
    }

    return [
      all.firstWhere((a) => a.type == ActionType.klaimBaru),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionMenuWidget(
      availableActions: _computeActions(),
      selectedItems: const [],
      onActionTap: (type, _) {
        final state = context.read<GroupcobCariBloc>().state;
        final selected = state.selectedKlaimRecord;

        if (selected == null) {
          if (type == ActionType.klaimBaru) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pilih data terlebih dahulu")),
          );
          return;
        }

        final cobId = selected.cobId;
        final klaim1Id = selected.klaim1Id;
        final cobNama = selected.cobNama;

        if (type == ActionType.perbaruiKlaim) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              if (cobId == "10002") {
                return PerbaruiKlaimMvPage(
                  klaim1Id: klaim1Id,
                  cobGroupNama: cobNama,
                );
              } else {
                return PerbaruiKlaimParPage(
                  klaim1Id: klaim1Id,
                  cobGroupNama: cobNama,
                  cobGroupId: cobId,
                );
              }
            }),
          );
          return;
        }

        if (type == ActionType.lacakKlaim) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KlaimProgressCariMainPage(klaim1Id: klaim1Id),
            ),
          );
          return;
        }

        if (type == ActionType.klaimBaru) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DaftarCobKlaimMenu()),
          );
          return;
        }

        debugPrint("Klaim action tapped: $type");
      },
    );
  }
}
