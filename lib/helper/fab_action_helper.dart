import 'package:flutter/material.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/detail_management_widget.dart';
import '../blocs/asetothers/asetotherscari_bloc.dart';
import '../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/gen_endors/endors1crud_form.dart';
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
      gradientColors: const [Color(0xFF48E0FF), Color(0xFF02B1D5)],
      borderColor: const Color(0xFF78E8FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lihatPolisEq,
      label: 'Unduh  Polis EQ',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFF48E0FF), Color(0xFF02B1D5)],
      borderColor: const Color(0xFF78E8FF),
      isEnabled: false,
    ),
    ActionMenuItem(
      type: ActionType.lihatPolis,
      label: 'Unduh Polis',
      iconAsset: 'assets/icons/unduh_polis.svg',
      gradientColors: const [Color(0xFF48E0FF), Color(0xFF02B1D5)],
      borderColor: const Color(0xFF78E8FF),
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
    'aktif': [ActionType.endorse, ActionType.unduhPolis],
    'diproses': [ActionType.lacakPolis],
    'tunggu pembayaran': [ActionType.lacakPolis],
    'jatuh tempo': [ActionType.perpanjangan],
    'berakhir': [ActionType.aktifkanKembali],
    'non aktif': [ActionType.aktifkanKembali],
  };

  // Method utama untuk mendapatkan available actions
  static List<ActionMenuItem> getAvailableActions({
    required String? currentStatusFilter,
    required List<dynamic> selectedItems,
  }) {
    // Tidak ada item terpilih → hanya always enabled yang ON
    if (selectedItems.isEmpty) {
      return masterActions.map((action) {
        return action.copyWith(
          isEnabled: alwaysEnabledActions.contains(action.type),
        );
      }).toList();
    }

    // Ada item terpilih → check status
    final status = _getStatusFromItem(selectedItems.first);
    final allowedActions = statusEnabledMatrix[status.toLowerCase().trim()] ?? [];

    return masterActions.map((action) {
      // Always enabled actions selalu ON
      if (alwaysEnabledActions.contains(action.type)) {
        return action.copyWith(isEnabled: true);
      }

      // Lainnya ON jika ada di allowed actions
      return action.copyWith(
        isEnabled: allowedActions.contains(action.type),
      );
    }).toList();
  }

  // Extract status dari item
  static String _getStatusFromItem(dynamic item) {
    try {
      if (item is Map<String, dynamic>) {
        return item['status']?.toString() ?? '';
      }
      if (item.toJson != null) {
        final json = item.toJson();
        return json['status']?.toString() ?? '';
      }
      return item.status?.toString() ?? '';
    } catch (_) {
      return '';
    }
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
        _navigateToEndorse(context, item, "Endorse", onActionComplete);
        break;
      case ActionType.perpanjangan:
        _navigateToEndorse(context, item, "Perpanjangan", onActionComplete);
        break;
      case ActionType.aktifkanKembali:
        _navigateToEndorse(context, item, "Aktifkan kembali", onActionComplete);
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

  static void _navigateToEndorse(
      BuildContext context,
      dynamic item,
      String pageTitle,
      VoidCallback? onComplete,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Endors1CrudFormPage(
          viewMode: "tambah",
          recordId: "",
          data: item,
          pageTitle: pageTitle,
        ),
      ),
    ).then((_) => onComplete?.call());
  }

  static void _handleLihatPolisPar(
      BuildContext context,
      VoidCallback? onComplete,
      ) {
    final polisId = context.read<AsetParCariBloc>().state.selectedFilePolisParId;

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Polis PAR belum dipilih"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<SppaDownloadPolisBloc>().add(DownloadFileEvent(ePolisId: polisId, cob: 'PAR'));

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

    context.read<SppaDownloadPolisBloc>().add(DownloadFileEvent(ePolisId: polisId, cob: 'PAR'));
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