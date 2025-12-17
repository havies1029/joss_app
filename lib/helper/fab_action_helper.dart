import 'package:flutter/material.dart';
import '../pages/asset_management/mobile/widget/detail_management_page/detail_management_widget.dart';
import '../pages/asset_management/floating_action_menu_widget.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/gen_endors/endors1crud_form.dart';

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
  ];

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailManagementPolisPage(data: item)),
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