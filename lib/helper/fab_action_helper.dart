import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/management_polis/mobile/form_button_page/endorse_form_page.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/detail_management_widget.dart';
import '../blocs/asetothers/asetotherscari_bloc.dart';
import '../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/management_polis/mobile/form_button_page/reactive_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/renewal_form_page.dart';

class FabActionHelper {
  // =========================
  // SINGLE SOURCE OF TRUTH READERS (NO PARAM LEMPAR2)
  // =========================
  static String _cobId(BuildContext c) =>
      c.read<CobManPolBloc>().state.selectedCOBId;

  static String? _statusId(BuildContext c) =>
      c.read<StatusAsetCariBloc>().state.selectedStatusId;

  static String _selectedId(BuildContext c) {
    final cobId = _cobId(c);
    return switch (cobId) {
      "10002" => c.read<AsetParCariBloc>().state.selectedId,
      "10003" => c.read<AsetMvCariBloc>().state.selectedId,
      "10004" => c.read<AsethullCariBloc>().state.selectedId,
      "10005" => c.read<AsetHealthCariBloc>().state.selectedId,
      "10006" => c.read<AsetothersCariBloc>().state.selectedId,
      _ => "",
    };
  }

  // kalau nanti multi-select beneran:
  // static List<String> _selectedIds(BuildContext c) {
  //   final cobId = _cobId(c);
  //   return switch (cobId) {
  //     "10002" => c.read<AsetParCariBloc>().state.selectedIds,
  //     "10003" => c.read<AsetMvCariBloc>().state.selectedIds,
  //     "10004" => c.read<AsethullCariBloc>().state.selectedIds,
  //     "10005" => c.read<AsetHealthCariBloc>().state.selectedIds,
  //     "10006" => c.read<AsetothersCariBloc>().state.selectedIds,
  //     _ => const <String>[],
  //   };
  // }

  // =========================
  // MASTER ACTIONS
  // =========================
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
        borderColor: const Color(0xFFFFC38E)),
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
    final allowedTypes = switch (cobId) {
      "10002" => <ActionType>{
        ActionType.beliPolis,
        ActionType.lacakPolis,
        ActionType.endorse,
        ActionType.perpanjangan,
        ActionType.aktifkanKembali,
        ActionType.lihatPolisPar,
        ActionType.lihatPolisEq,
      },
      "10003" || "10004" || "10005" || "10006" => <ActionType>{
        ActionType.beliPolis,
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

  static final List<ActionType> alwaysEnabledActions = [ActionType.beliPolis];

  static final Map<String, List<ActionType>> statusEnabledMatrix = {
    'aktif': [ActionType.endorse, ActionType.unduhPolis], // fix duplikat endorse
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

  // =========================
  // GET AVAILABLE ACTIONS
  // PARAM TETAP SAMA (tapi sekarang bisa "optional dipakai")
  // kalau caller masih lempar, tetap jalan. Tapi kita bisa fallback ke state.
  // =========================
  static List<ActionMenuItem> getAvailableActions({
    required String? currentStatusFilter,
    required List<dynamic> selectedItems,
    BuildContext? context, // <- tambahan OPTIONAL supaya bisa baca state bila mau
  }) {
    final statusId = currentStatusFilter ?? (context != null ? _statusId(context) : null);

    // kalau caller ngirim selectedItems kosong tapi kamu pengen ambil dari state:
    // (opsional, kalau kamu mau strict, hapus block ini)
    final items = (selectedItems.isNotEmpty || context == null)
        ? selectedItems
        : _selectedModelsFromState(context);

    if (items.isEmpty) {
      return masterActions
          .map((a) => a.copyWith(isEnabled: alwaysEnabledActions.contains(a.type)))
          .toList();
    }

    final statusKey = _mapStatusIdToKey(statusId);
    final allowedActions = statusEnabledMatrix[statusKey] ?? [];

    return masterActions.map((action) {
      if (alwaysEnabledActions.contains(action.type)) {
        return action.copyWith(isEnabled: true);
      }
      return action.copyWith(isEnabled: allowedActions.contains(action.type));
    }).toList();
  }

  // helper: resolve selected model list dari state (sementara masih manual)
  static List<dynamic> _selectedModelsFromState(BuildContext c) {
    final cobId = _cobId(c);
    final id = _selectedId(c);
    if (id.isEmpty) return const [];

    try {
      final item = switch (cobId) {
        "10002" => c.read<AsetParCariBloc>().state.items
            .firstWhere((x) => x.asetParId == id),
        "10003" => c.read<AsetMvCariBloc>().state.items
            .firstWhere((x) => x.asetMvId == id),
        "10004" => c.read<AsethullCariBloc>().state.items
            .firstWhere((x) => x.asetHullId == id),
        "10005" => c.read<AsetHealthCariBloc>().state.items
            .firstWhere((x) => x.asethealthId == id),
        "10006" => c.read<AsetothersCariBloc>().state.items
            .firstWhere((x) => x.asetOthersId == id),
        _ => null,
      };
      return item == null ? const [] : [item];
    } catch (_) {
      return const [];
    }
  }

  // =========================
  // ACTION TAP (tetap signature sama)
  // =========================
  static void handleAction({
    required BuildContext context,
    required ActionType actionType,
    required List<dynamic> selectedItems,
    VoidCallback? onActionComplete,
  }) {
    if (alwaysEnabledActions.contains(actionType)) {
      _handleAlwaysEnabled(context, actionType, onActionComplete);
      return;
    }

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Pilih Minimal 1 Item!"),
      );
      return;
    }

    switch (actionType) {
      case ActionType.lacakPolis:
        _navigateToDetail(context, selectedItems.first, onActionComplete);
        break;
      case ActionType.endorse:
        _handleEndorse(context, onActionComplete);
        break;
      case ActionType.perpanjangan:
        _handleRenewal(context, onActionComplete);
        break;
      case ActionType.aktifkanKembali:
        _handleReactive(context, onActionComplete);
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
    }
  }

  static bool ensurePolisSelected(BuildContext c, String polisId) {
    if (polisId.isNotEmpty) return true;

    ScaffoldMessenger.of(c).showSnackBar(
      infoSnackBar("Pilih Polis Terlebih Dahulu!"),
    );
    return false;
  }

  // (masih boleh ada kalau dipakai tempat lain, tapi internal helper sekarang pakai _selectedId)
  static String selectedIdByCob(BuildContext c) => _selectedId(c);

  // =========================
  // HANDLERS: cobId/selectedId ambil dari STATE
  // =========================
  static void _handleEndorse(BuildContext c, VoidCallback? done) {
    final cobId = _cobId(c);
    final sppaId = _selectedId(c);

    if (!ensurePolisSelected(c, sppaId)) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _handleRenewal(BuildContext c, VoidCallback? done) {
    final cobId = _cobId(c);
    final sppaId = _selectedId(c);

    if (!ensurePolisSelected(c, sppaId)) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => RenewalFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _handleReactive(BuildContext c, VoidCallback? done) {
    final cobId = _cobId(c);
    final sppaId = _selectedId(c);

    if (!ensurePolisSelected(c, sppaId)) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => ReaktifFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
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
        ScaffoldMessenger.of(context).showSnackBar(
          infoSnackBar("Mengunduh Polis..."),
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
    final cobId = _cobId(context);
    final statusId = _statusId(context);

    if (cobId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("COB Belum Dipilih!"),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailManagementPolisPage(
          data: item,
          cobId: cobId,
          statusId: statusId ?? "",
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
        infoSnackBar("Polis Properti Belum Dipilih!"),
      );
      return;
    }

    context.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: polisId, cob: 'PAR'),
    );

    onComplete?.call();
  }

  static void _handleLihatPolisEq(
      BuildContext context,
      VoidCallback? onComplete,
      ) {
    final polisId = context.read<AsetParCariBloc>().state.selectedFilePolisEqId;

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Polis EQ Belum Dipilih!"),
      );
      return;
    }

    context.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: polisId, cob: 'PAR'),
    );

    onComplete?.call();
  }

  static void _handleLihatPolisGeneric(
      BuildContext context,
      VoidCallback? onComplete,
      ) {
    final cobId = _cobId(context);

    final polisId = switch (cobId) {
      "10003" => context.read<AsetMvCariBloc>().state.selectedFilePolisId,
      "10004" => context.read<AsethullCariBloc>().state.selectedFilePolisId,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedFilePolisId,
      "10006" => context.read<AsetothersCariBloc>().state.selectedFilePolisId,
      _ => "",
    };

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Polis Belum Dipilih!"),
      );
      return;
    }

    final downloadBloc = context.read<SppaDownloadPolisBloc>();

    switch (cobId) {
      case "10003":
        downloadBloc.add(DownloadFileEvent(ePolisId: polisId, cob: 'MV'));
        break;
      case "10004":
        downloadBloc.add(DownloadFileEvent(ePolisId: polisId, cob: 'HULL'));
        break;
      case "10005":
        downloadBloc.add(DownloadFileEvent(ePolisId: polisId, cob: 'HEALTH'));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          infoSnackBar("COB Tidak Dikenali!"),
        );
        return;
    }

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


/*

import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/management_polis/mobile/form_button_page/endorse_form_page.dart';
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

import '../pages/management_polis/mobile/form_button_page/reactive_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/renewal_form_page.dart';

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
    // gak ada selection → hanya always enabled
    if (selectedItems.isEmpty) {
      return masterActions.map((a) {
        return a.copyWith(
          isEnabled: alwaysEnabledActions.contains(a.type),
        );
      }).toList();
    }

    // STATUS DARI FILTER, BUKAN ITEM
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
        infoSnackBar("Pilih Minimal 1 Item!")
      );
      return;
    }

    final item = selectedItems.first;

    switch (actionType) {
      case ActionType.lacakPolis:       _navigateToDetail(context, selectedItems.first, onActionComplete); break;
      case ActionType.endorse:          _handleEndorse(context, onActionComplete); break;
      case ActionType.perpanjangan:     _handleRenewal(context, onActionComplete); break;
      case ActionType.aktifkanKembali:  _handleReactive(context, onActionComplete); break;
      case ActionType.lihatPolisPar:    _handleLihatPolisPar(context, onActionComplete); break;
      case ActionType.lihatPolisEq:     _handleLihatPolisEq(context, onActionComplete); break;
      case ActionType.lihatPolis:       _handleLihatPolisGeneric(context, onActionComplete); break;
      default:                          _handleAlwaysEnabled(context, actionType, onActionComplete);
    }
  }

  static bool ensurePolisSelected(BuildContext c, String polisId) {
    if (polisId.isNotEmpty) return true;

    ScaffoldMessenger.of(c).showSnackBar(
      infoSnackBar("Pilih Polis Terlebih Dahulu!")
    );
    return false;
  }

  static String selectedIdByCob(BuildContext c) {
    final cobId = c.read<CobManPolBloc>().state.selectedCOBId;

    return switch (cobId) {
      "10002" => c.read<AsetParCariBloc>().state.selectedId,
      "10003" => c.read<AsetMvCariBloc>().state.selectedId,
      "10004" => c.read<AsethullCariBloc>().state.selectedId,
      "10005" => c.read<AsetHealthCariBloc>().state.selectedId,
      "10006" => c.read<AsetothersCariBloc>().state.selectedId,
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

  static void _handleEndorse(BuildContext c, VoidCallback? done) {
    final cobId = c.read<CobManPolBloc>().state.selectedCOBId;
    final sppaId = selectedIdByCob(c);
    if (!ensurePolisSelected(c, sppaId)) return;
    debugPrint("══════════════════════════════");
    debugPrint("Endorse");
    debugPrint("📦 COB ID   : $cobId");
    debugPrint("🆔 POLIS ID: $sppaId");
    debugPrint("══════════════════════════════");
    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _handleRenewal(BuildContext c, VoidCallback? done) {
    final cobId = c.read<CobManPolBloc>().state.selectedCOBId;
    final sppaId = selectedIdByCob(c);
    if (!ensurePolisSelected(c, sppaId)) return;
    debugPrint("══════════════════════════════");
    debugPrint("Renewal");
    debugPrint("📦 COB ID   : $cobId");
    debugPrint("🆔 POLIS ID: $sppaId");
    debugPrint("══════════════════════════════");
    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => RenewalFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _handleReactive(BuildContext c, VoidCallback? done) {
    final cobId = c.read<CobManPolBloc>().state.selectedCOBId;
    final sppaId = selectedIdByCob(c);
    if (!ensurePolisSelected(c, sppaId)) return;
    debugPrint("══════════════════════════════");
    debugPrint("Reactive");
    debugPrint("📦 COB ID   : $cobId");
    debugPrint("🆔 POLIS ID: $sppaId");
    debugPrint("══════════════════════════════");
    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => ReaktifFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppaId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
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
          infoSnackBar("Mengunduh Polis...")
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
        infoSnackBar("COB Belum Dipilih!")
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

  static void _handleLihatPolisPar(
    BuildContext context,
    VoidCallback? onComplete,
  ) {
    final polisId =
        context.read<AsetParCariBloc>().state.selectedFilePolisParId;

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Polis Properti Belum Dipilih!")
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
        infoSnackBar("Polis EQ Belum Dipilih!")
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

    final polisId = switch (cobId) {
      "10003" => context.read<AsetMvCariBloc>().state.selectedFilePolisId,
      "10004" => context.read<AsethullCariBloc>().state.selectedFilePolisId,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedFilePolisId,
      "10006" => context.read<AsetothersCariBloc>().state.selectedFilePolisId,
      _ => "",
    };

    if (polisId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Polis Belum Dipilih!")
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
          infoSnackBar("COB Tidak Dikenali!")
        );
        return;
    }
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

 */