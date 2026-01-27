import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_endors/mobile/form_endorse.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/detail_management_widget.dart';
import '../blocs/asetothers/asetotherscari_bloc.dart';
import '../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabActionHelper {
  static final List<ActionMenuItem> masterActions = [
    ActionMenuItem(
      type: ActionType.beliPolis,
      label: 'Beli Polis',
      iconAsset: 'assets/icons/beli_polis1.svg',
      gradientColors: const [Color(0xFFFFCA46), Color(0xFFD59900)],
      borderColor: const Color(0xFFFFDF8E),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.unduhPolis,
      label: 'Unduh Polis',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFF42EF48), Color(0xFF05AD0A)],
      borderColor: const Color(0xFF43FB49),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lacakPolis,
      label: 'Lacak Polis',
      iconAsset: 'assets/icons/lacak_polis.svg',
      gradientColors: const [Color(0xFF48E0FF), Color(0xFF02B1D5)],
      borderColor: const Color(0xFF78E8FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.endorse,
      label: 'Endorse',
      iconAsset: 'assets/icons/endorse.svg',
      gradientColors: const [Color(0xFF61C8FF), Color(0xFF0486CD)],
      borderColor: const Color(0xFF57C4FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.perpanjangan,
      label: 'Perpanjangan',
      iconAsset: 'assets/icons/perpanjangan.svg',
      gradientColors: const [Color(0xFF9B82FF), Color(0xFF533BB6)],
      borderColor: const Color(0xFFAC98FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.aktifkanKembali,
      label: 'Aktifkan',
      iconAsset: 'assets/icons/aktifkan_kembali.svg',
      gradientColors: const [Color(0xFFFF393D), Color(0xFFAC0A0D)],
      borderColor: const Color(0xFFFF787B),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lihatPolisPar,
      label: 'Unduh Polis PAR',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFF46A5FF), Color(0xFF0040D5)],
      borderColor: const Color(0xFF8EB8FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lihatPolisEq,
      label: 'Unduh Polis EQ',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFFFFB546), Color(0xFFD57200)],
      borderColor: const Color(0xFFFFC38E),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lihatPolis,
      label: 'Unduh Polis',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFF42EF48), Color(0xFF05AD0A)],
      borderColor: const Color(0xFF43FB49),
      isEnabled: false,
    ),
  ];

  static List<ActionMenuItem> visibleActionsByCob({
    required String cobId,
    required List<ActionMenuItem> actions,
  }) {
    // whitelist per cob
    final allowedTypes = switch (cobId) {
      "10002" => <ActionType>{
          ActionType.beliPolis,
          // ActionType.unduhPolis,
          ActionType.lacakPolis,
          ActionType.endorse,
          ActionType.perpanjangan,
          ActionType.aktifkanKembali,
          ActionType.lihatPolisPar,
          ActionType.lihatPolisEq,
        },
      "10003" || "10004" || "10005" || "10006" => <ActionType>{
          ActionType.beliPolis,
          // ActionType.unduhPolis,
          ActionType.lacakPolis,
          ActionType.endorse,
          ActionType.perpanjangan,
          ActionType.aktifkanKembali,
          ActionType.lihatPolis,
        },
      _ => <ActionType>{ActionType.beliPolis},
    };

    return actions.where((a) => allowedTypes.contains(a.type)).toList();
  }

  // Actions yang selalu enabled
  static final List<ActionType> alwaysEnabledActions = [ActionType.beliPolis];

  // Permission berdasarkan status
  static final Map<String, List<ActionType>> statusEnabledMatrix = {
    'aktif': [ActionType.endorse, ActionType.unduhPolis, ActionType.endorse],
    'diproses': [ActionType.lacakPolis],
    'tunggu pembayaran': [ActionType.lacakPolis],
    'jatuh tempo': [ActionType.perpanjangan],
    'berakhir': [ActionType.aktifkanKembali],
    'non aktif': [ActionType.aktifkanKembali],
  };

  static String _mapStatusIdToKey(String? statusId) {
    switch (statusId) {
      case "10001":
        return "aktif";
      case "10002":
        return "diproses";
      case "10003":
        return "tunggu pembayaran";
      case "10004":
        return "jatuh tempo";
      case "10005":
        return "berakhir";
      case "10006":
        return "non aktif";
      default:
        return "";
    }
  }

  // Method utama untuk mendapatkan available actions
  static List<ActionMenuItem> getAvailableActions({
    required String? currentStatusFilter,
    required List<dynamic> selectedItems,
  }) {
    // ❌ gak ada selection → hanya always enabled
    if (selectedItems.isEmpty) {
      return masterActions.map((a) {
        return a.copyWith(
          isEnabled: alwaysEnabledActions.contains(a.type),
        );
      }).toList();
    }

    // ✅ STATUS DARI FILTER, BUKAN ITEM
    final statusKey = _mapStatusIdToKey(currentStatusFilter);
    final allowedActions = statusEnabledMatrix[statusKey] ?? [];

    return masterActions.map((action) {
      if (alwaysEnabledActions.contains(action.type)) {
        return action.copyWith(isEnabled: true);
      }

      return action.copyWith(
        isEnabled: allowedActions.contains(action.type),
      );
    }).toList();
  }

  // Handle action tap
  static void handleAction({
    required BuildContext context,
    required ActionType actionType,
    required List<dynamic> selectedItems,
    VoidCallback? onActionComplete,
  }) {
    // Always enabled actions tidak butuh selection
    if (alwaysEnabledActions.contains(actionType)) {
      _handleAlwaysEnabled(context, actionType, onActionComplete);
      return;
    }

    // Actions lain butuh minimal 1 item
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Pilih minimal 1 item"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final item = selectedItems.first;

    switch (actionType) {
      case ActionType.lacakPolis:
        _navigateToDetail(context, item, onActionComplete);
        break;
      case ActionType.endorse:
        _handleEndorse(context, "Endorse", onActionComplete);
        break;

      case ActionType.perpanjangan:
        _handleEndorse(context, "Perpanjangan", onActionComplete);
        break;

      case ActionType.aktifkanKembali:
        _handleEndorse(context, "Aktifkan kembali", onActionComplete);
        break;
      case ActionType.lihatPolisPar:
        _handleLihatPolisPar(context, onActionComplete);
        break;

      case ActionType.lihatPolisEq:
        _handleLihatPolisEq(context, onActionComplete);
        break;

      case ActionType.lihatPolis:
        _handleLihatPolisGeneric(context, onActionComplete);
        break;
      default:
        _handleAlwaysEnabled(context, actionType, onActionComplete);
        break;
    }
  }

  static String _getSelectedPolisIdByCob(BuildContext context, String cobId) {
    return switch (cobId) {
      "10002" => context.read<AsetParCariBloc>().state.selectedId,
      "10003" => context.read<AsetMvCariBloc>().state.selectedFilePolisId,
      "10004" => context.read<AsethullCariBloc>().state.selectedFilePolisId,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedFilePolisId,
      "10006" => context.read<AsetothersCariBloc>().state.selectedFilePolisId,
      _ => "",
    };
  }

  // Helper untuk ambil polisId dari item yang dipilih
  static String _getPolisIdFromSelectedItem(
      BuildContext context, String cobId) {
    try {
      return switch (cobId) {
        "10002" => () {
            final state = context.read<AsetParCariBloc>().state;
            if (state.selectedIds.isEmpty) return "";

            // Ambil item pertama yang dipilih
            final selectedItem = state.items.firstWhere(
              (x) => state.selectedIds.contains(x.asetParId),
            );
            return selectedItem.asetParId ?? selectedItem.polisNo ?? "";
          }(),
        "10003" => () {
            final state = context.read<AsetMvCariBloc>().state;
            if (state.selectedIds.isEmpty) return "";

            final selectedItem = state.items.firstWhere(
              (x) => state.selectedIds.contains(x.asetMvId),
            );
            return selectedItem.asetMvId ?? selectedItem.polisNo ?? "";
          }(),
        "10004" => () {
            final state = context.read<AsethullCariBloc>().state;
            if (state.selectedIds.isEmpty) return "";

            final selectedItem = state.items.firstWhere(
              (x) => state.selectedIds.contains(x.asetHullId),
            );

            return selectedItem.asetHullId ?? selectedItem.polisNo ?? "";
          }(),
        "10005" => () {
            final state = context.read<AsetHealthCariBloc>().state;
            if (state.selectedIds.isEmpty) return "";

            final selectedItem = state.items.firstWhere(
              (x) => state.selectedIds.contains(x.asethealthId),
            );

            return selectedItem.asethealthId ?? selectedItem.polisNo ?? "";
          }(),
        "10006" => () {
            final state = context.read<AsetothersCariBloc>().state;
            if (state.selectedIds.isEmpty) return "";

            final selectedItem = state.items.firstWhere(
              (x) => state.selectedIds.contains(x.asetOthersId),
            );

            return selectedItem.asetOthersId ?? selectedItem.polisNo ?? "";
          }(),
        _ => "",
      };
    } catch (e) {
      debugPrint("Error getting polisId from item: $e");
      return "";
    }
  }

  static void _handleEndorse(
    BuildContext context,
    String pageTitle,
    VoidCallback? onComplete,
  ) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

    String sppaId = _getSelectedPolisIdByCob(context, cobId);

    debugPrint("🔍 cobId: $cobId");
    debugPrint("🔍 sppaId from state: $sppaId");

    if (sppaId.isEmpty) {
      sppaId = _getPolisIdFromSelectedItem(context, cobId);
      debugPrint("🔍 sppaId from item: $sppaId");
    }

    if (sppaId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Pilih polis terlebih dahulu"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
          pageTitle: pageTitle,
        ),
      ),
    ).then((_) => onComplete?.call());
  }

  static void _handleAlwaysEnabled(
    BuildContext context,
    ActionType type,
    VoidCallback? onComplete,
  ) {
    switch (type) {
      case ActionType.beliPolis:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BeliPolisPage()),
        ).then((_) => onComplete?.call());
        break;
      case ActionType.unduhPolis:
        debugPrint("📥 Download Polis...");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("📄 Mengunduh polis..."),
            backgroundColor: Colors.green,
          ),
        );
        onComplete?.call();
        break;
      default:
        break;
    }
  }

  static void _navigateToDetail(
    BuildContext context,
    dynamic item,
    VoidCallback? onComplete,
  ) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
    if (cobId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("COB belum dipilih"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailManagementPolisPage(
          data: item,
          cobId: cobId,
        ),
      ),
    ).then((_) => onComplete?.call());
  }

  // static void _navigateToEndorse(
  //     BuildContext context,
  //     dynamic item,
  //     String pageTitle,
  //     VoidCallback? onComplete,
  //     ) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => EndorseFormPage(
  //         viewMode: "tambah",
  //         recordId: "",
  //         data: item,
  //         pageTitle: pageTitle,
  //       ),
  //     ),
  //   ).then((_) => onComplete?.call());
  // }

  static void _handleLihatPolisPar(
    BuildContext context,
    VoidCallback? onComplete,
  ) {
    final polisId =
        context.read<AsetParCariBloc>().state.selectedFilePolisParId;

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Polis PAR belum dipilih"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context
        .read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: polisId, cob: 'PAR'));

    onComplete?.call();
  }

  static void _handleLihatPolisEq(
    BuildContext context,
    VoidCallback? onComplete,
  ) {
    final polisId = context.read<AsetParCariBloc>().state.selectedFilePolisEqId;

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Polis EQ belum dipilih"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context
        .read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: polisId, cob: 'PAR'));
    onComplete?.call();
  }

  static void _handleLihatPolisGeneric(
    BuildContext context,
    VoidCallback? onComplete,
  ) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

    // 1️⃣ Ambil polisId berdasarkan COB
    final polisId = switch (cobId) {
      "10003" => context.read<AsetMvCariBloc>().state.selectedFilePolisId,
      "10004" => context.read<AsethullCariBloc>().state.selectedFilePolisId,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedFilePolisId,
      "10006" => context.read<AsetothersCariBloc>().state.selectedFilePolisId,
      _ => "",
    };

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Polis belum dipilih"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final downloadBloc = context.read<SppaDownloadPolisBloc>();

    switch (cobId) {
      case "10003": // MV
        downloadBloc.add(
          DownloadFileEvent(
            ePolisId: polisId,
            cob: 'MV',
          ),
        );
        break;

      case "10004": // HULL
        downloadBloc.add(
          DownloadFileEvent(
            ePolisId: polisId,
            cob: 'HULL',
          ),
        );
        break;

      case "10005": // HEALTH
        downloadBloc.add(
          DownloadFileEvent(
            ePolisId: polisId,
            cob: 'HEALTH',
          ),
        );
        break;

      // case "10006": // OTHERS
      //   downloadBloc.add(
      //     DownloadFileEvent(
      //       ePolisId: polisId,
      //       cob: 'OTHERS',
      //     ),
      //   );
      //   break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠ COB tidak dikenali"),
            backgroundColor: Colors.red,
          ),
        );
        return;
    }

    // debugPrint("⬇️ Download Polis: id=$polisId, cob=$cobId");
    onComplete?.call();
  }
}

extension ActionMenuItemCopy on ActionMenuItem {
  ActionMenuItem copyWith({
    ActionType? type,
    String? label,
    String? iconAsset,
    List<Color>? gradientColors,
    Color? borderColor,
    bool? isEnabled,
  }) {
    return ActionMenuItem(
      type: type ?? this.type,
      label: label ?? this.label,
      iconAsset: iconAsset ?? this.iconAsset,
      gradientColors: gradientColors ?? this.gradientColors,
      borderColor: borderColor ?? this.borderColor,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
