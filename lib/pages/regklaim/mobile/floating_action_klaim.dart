
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/daftar_cob_klaim_page.dart';
import '../../../common/constants.dart';
import '../../../widgets/apptheme/hubungi_cs.dart';
import '../../klaimbatal/mobile/klaimbatalcrud_form.dart';
import '../../klaimlacak/mobile/klaimprogresscari_main.dart';
import '../../perbaruiklaimmv/mobile/perbaruiklaimmv_page.dart';
import '../../perbaruiklaimpar/mobile/perbaruiklaimpar_page.dart';

class FabActionKlaim extends StatelessWidget {
  final int selectedTab;

  const FabActionKlaim({super.key, required this.selectedTab});

  Future<void> showLacakBelumTersediaDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SvgPicture.asset(
                      "assets/icons/lacak_klaim_kehilangan.svg",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Informasi Klaim Kehilangan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Informasi klaim kehilangan kendaraan dapat diperoleh melalui Bagian Klaim. Silakan hubungi Bagian Klaim untuk informasi lebih lanjut.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rBlue,
                        foregroundColor: primaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showHubungiJps(context);
                      },
                      child: Text(
                        "Hubungi",
                        style: TextStyle(
                          fontSize: getResponsiveFont(context, 16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  void showHubungiJps(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) {
        return HubungiCs(
          mlayanan1Id: '01',
          onPilihLayanan: (noTelepon) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No telepon: $noTelepon"),
              ),
            );

            // TODO: arahkan ke chat / page tujuan
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupcobCariBloc, GroupcobCariState>(
      builder: (context, state) {
        // debugPrint("Selected ID: ${state.selectedId}");
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
          isLacak = selected?.isLacak == true;
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
            gradientColors: const [Color(0xFFF484B), Color(0xFFC30003)],
            borderColor: const Color(0xFFFF787A),
            isEnabled: isBerjalan,
          ),
          ActionMenuItem(
            type: ActionType.hubungiJps,
            label: "Hubungi Proteksi Plus",
            iconAsset: "assets/icons/cs_klaim.svg",
            gradientColors: const [Color(0xFFF69713), Color(0xFFFFF782)],
            borderColor: const Color(0xFFFFD06C),
            isEnabled: true,
          ),
        ];

        return FloatingActionMenuWidget(
          availableActions: actions,
          selectedItems: const [],
            onActionTap: (type, _) {
              if (type == ActionType.hubungiJps) {
                showHubungiJps(context);
                return;
              }

              if (selected == null) {
                if (type == ActionType.klaimBaru) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pilih data terlebih dahulu")),
                  );
                }
                return;
              }

              switch (type) {
                case ActionType.perbaruiKlaim:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => selected!.cobId == "10002"
                          ? PerbaruiKlaimMvPage(
                        klaim1Id: selected.klaim1Id,
                        cobGroupNama: selected.cobNama,
                      )
                          : PerbaruiKlaimParPage(
                        klaim1Id: selected.klaim1Id,
                        cobGroupNama: selected.cobNama,
                        cobGroupId: selected.cobId,
                      ),
                    ),
                  );
                  break;

                case ActionType.lacakKlaim:
                  if (selected?.isLacak != true) {
                    showLacakBelumTersediaDialog(context);
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KlaimProgressCariMainPage(
                        klaim1Id: selected!.klaim1Id,
                        statusDesc: selected!.statusDesc,
                      ),
                    ),
                  );
                  break;

                case ActionType.batalKlaim:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KlaimbatalcrudFormPage(
                        klaim1Id: selected!.klaim1Id,
                      ),
                    ),
                  );
                  break;

                case ActionType.klaimBaru:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()),
                  );
                  break;

                default:
                  break;
              }
            }
        );
      },
    );
  }
}