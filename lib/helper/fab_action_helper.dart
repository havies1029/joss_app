import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/management_polis/mobile/form_button_page/endorse_form_page.dart';
import '../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/management_polis/detail_management_page/detail_management_widget_2.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/management_polis/mobile/form_button_page/reactive_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/renewal_form_page.dart';


class FabActionHelper {
  static String _cobId(BuildContext c) =>
      c.read<CobManPolBloc>().state.selectedCOBId;

  static String? _statusId(BuildContext c) =>
      c.read<StatusAsetCariBloc>().state.selectedStatusId;

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

  static final ActionMenuItem downloadPolisItem = ActionMenuItem(
    type: ActionType.unduhPolis,
    label: 'Unduh Polis',
    iconAsset: 'assets/icons/unduh_polis.svg',
    gradientColors: const [Color(0xFF42EF48), Color(0xFF05AD0A)],
    borderColor: const Color(0xFF43FB49),
    isEnabled: true,
  );

  static final ActionMenuItem downloadParItem = ActionMenuItem(
    type: ActionType.lihatPolisPar,
    label: 'Unduh Polis PAR',
    iconAsset: 'assets/icons/unduh_polis.svg',
    gradientColors: const [Color(0xFF46A5FF), Color(0xFF0040D5)],
    borderColor: const Color(0xFF8EB8FF),
    isEnabled: true,
  );

  static final ActionMenuItem downloadEqItem = ActionMenuItem(
    type: ActionType.lihatPolisEq,
    label: 'Unduh Polis EQ',
    iconAsset: 'assets/icons/unduh_polis.svg',
    gradientColors: const [Color(0xFFFFB546), Color(0xFFD57200)],
    borderColor: const Color(0xFFFFC38E),
    isEnabled: true,
  );


  static final List<ActionType> alwaysEnabledActions = [ActionType.beliPolis];

  static final Map<String, List<ActionType>> prosesSourceEnabledMatrix = {
    "E": <ActionType>[ActionType.lacakPolis],
    "R": <ActionType>[ActionType.lacakPolis],
    "A": <ActionType>[ActionType.lacakPolis],
  };

  static final Map<String, List<ActionType>> statusIdEnabledMatrix = {
    "10001": <ActionType>[ActionType.endorse],
    "10002": <ActionType>[ActionType.lacakPolis],        // <— lacak cuma di sini
    "10003": <ActionType>[ActionType.aktifkanKembali],
    "10004": <ActionType>[ActionType.perpanjangan],
  };

  /*
  /**/
  // LEGACY: matrix lama berbasis status (untuk presentasi / fallback)
  static final Map<String, List<ActionType>> statusEnabledMatrix = {
    'aktif': [ActionType.endorse, ActionType.unduhPolis],
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
  /**/
  */

  /// Ambil prosesSource dari selected item (dynamic)
  /// Support beberapa kemungkinan nama field (biar tahan banting).
  static String _prosesSourceFromItem(dynamic item) {
    try {
      final v = (item.prosesSource ?? "").toString();
      if (v.isNotEmpty) return v;
    } catch (_) {}

    // fallback kalau item Map
    if (item is Map) {
      final v = (item["prosesSource"] ?? "").toString();
      if (v.isNotEmpty) return v;
    }

    return "";
  }

  static bool _canLacak(dynamic item) {
    // coba akses sebagai object
    try {
      final ps = (item.prosesSource ?? "").toString();
      final pid = (item.prosesId ?? "").toString();
      if (ps.isNotEmpty && pid.isNotEmpty) return true;
    } catch (_) {}

    // fallback kalau item Map
    if (item is Map) {
      final ps = (item["prosesSource"] ?? "").toString();
      final pid = (item["prosesId"] ?? "").toString();
      if (ps.isNotEmpty && pid.isNotEmpty) return true;
    }

    return false;
  }

  static List<ActionMenuItem> getAvailableActions({
    required BuildContext context,
    required List<dynamic> selectedItems,
  }) {
    if (selectedItems.isEmpty) {
      return masterActions
          .map((a) => a.copyWith(
        isEnabled: alwaysEnabledActions.contains(a.type),
      ))
          .toList();
    }

    final item = selectedItems.first;
    final cobId = _cobId(context);

    final statusId = _statusId(context) ?? "";
    final allowedByStatus =
        statusIdEnabledMatrix[statusId] ?? const <ActionType>[];

    final lacakEnabled =
    (allowedByStatus.contains(ActionType.lacakPolis) && _canLacak(item))
        ? <ActionType>[ActionType.lacakPolis]
        : const <ActionType>[];

    final allowedByStatusNoLacak =
    allowedByStatus.where((t) => t != ActionType.lacakPolis).toList();

    final allowed = <ActionType>{
      ...alwaysEnabledActions,
      ...lacakEnabled,
      ...allowedByStatusNoLacak,
    };

    final base = masterActions
        .where((a) => allowed.contains(a.type))
        .map((a) => a.copyWith(isEnabled: true))
        .toList();

    if (cobId == "10002") {
      final parId = (item.filePolisParId ?? "").toString();
      final eqId = (item.filePolisEqId ?? "").toString();

      base.add(downloadParItem.copyWith(isEnabled: parId.isNotEmpty));
      base.add(downloadEqItem.copyWith(isEnabled: eqId.isNotEmpty));
    } else {
      final fileId = (item.filePolisId ?? "").toString();
      base.add(downloadPolisItem.copyWith(isEnabled: fileId.isNotEmpty));
    }

    return base;
  }



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
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Pilih Minimal 1 Item!"));
      return;
    }

    final item = selectedItems.first;
    final cobId = _cobId(context);

    switch (actionType) {
      case ActionType.lacakPolis:
        _navigateToDetail(context, item, onActionComplete);
        break;
      case ActionType.endorse:
        _openEndorse(context, cobId, item, onActionComplete);
        break;
      case ActionType.perpanjangan:
        _openRenewal(context, cobId, item, onActionComplete);
        break;
      case ActionType.aktifkanKembali:
        _openReactive(context, cobId, item, onActionComplete);
        break;

      case ActionType.unduhPolis:
        _downloadGeneric(context, cobId, item);
        break;
      case ActionType.lihatPolisPar:
        _downloadPar(context, item);
        break;
      case ActionType.lihatPolisEq:
        _downloadEq(context, item);
        break;

      default:
        _handleAlwaysEnabled(context, actionType, onActionComplete);
    }
  }

  static String _polisIdFromItem(String cobId, dynamic item) {
    return switch (cobId) {
      "10002" => item.asetParId,
      "10003" => item.asetMvId,
      "10004" => item.asetHullId,
      "10005" => item.asethealthId,
      "10006" => item.asetOthersId,
      _ => "",
    };
  }

  static void _openEndorse(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _openRenewal(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => RenewalFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _openReactive(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => ReaktifFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _downloadGeneric(BuildContext c, String cobId, dynamic item) {
    final polisFileId = item.filePolisId;
    if (polisFileId.isEmpty) return;

    final bloc = c.read<SppaDownloadPolisBloc>();

    final cob = switch (cobId) {
      "10003" => "MV",
      "10004" => "HULL",
      "10005" => "HEALTH",
      "10006" => "OTHERS", // bonus perbaikan
      _ => "",
    };

    if (cob.isEmpty) return;

    bloc.add(DownloadFileEvent(ePolisId: polisFileId, cob: cob));
  }

  static void _downloadPar(BuildContext c, dynamic item) {
    if (item.filePolisParId.isEmpty) return;
    c.read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: item.filePolisParId, cob: 'PAR'));
  }

  static void _downloadEq(BuildContext c, dynamic item) {
    if (item.filePolisEqId.isEmpty) return;
    c.read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: item.filePolisEqId, cob: 'PAR'));
  }

  static void _handleAlwaysEnabled(
      BuildContext context, ActionType type, VoidCallback? onComplete) {
    switch (type) {
      case ActionType.beliPolis:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BeliPolisPage()),
        ).then((_) => onComplete?.call());
        break;
      case ActionType.unduhPolis:
        ScaffoldMessenger.of(context)
            .showSnackBar(infoSnackBar("Mengunduh Polis..."));
        onComplete?.call();
        break;
      default:
        break;
    }
  }

  /// NOTE: statusId tidak perlu lagi untuk detail tracking,
  /// jadi _navigateToDetail cukup mengirim data + cobId.
  /// Kalau constructor DetailManagementPolisPage masih minta statusId,
  /// kirim empty string aja (atau kamu bisa hapus parameter statusId di page).
  static void _navigateToDetail(
      BuildContext context, dynamic item, VoidCallback? onComplete) {
    final cobId = _cobId(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailManagementPolisPage2(
          data: item,
          cobId: cobId,
          statusId: "", // <- status tidak dipakai lagi untuk routing proses
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


/*
class FabActionHelper {
  static String _cobId(BuildContext c) =>
      c.read<CobManPolBloc>().state.selectedCOBId;

  static String? _statusId(BuildContext c) =>
      c.read<StatusAsetCariBloc>().state.selectedStatusId;

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

  static final List<ActionType> alwaysEnabledActions = [ActionType.beliPolis];

  static final Map<String, List<ActionType>> statusEnabledMatrix = {
    'aktif': [ActionType.endorse, ActionType.unduhPolis],
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

  static List<ActionMenuItem> getAvailableActions({
    required String? currentStatusFilter,
    required List<dynamic> selectedItems,
  }) {
    if (selectedItems.isEmpty) {
      return masterActions
          .map((a) => a.copyWith(isEnabled: alwaysEnabledActions.contains(a.type)))
          .toList();
    }

    final statusKey = _mapStatusIdToKey(currentStatusFilter);
    final allowedActions = statusEnabledMatrix[statusKey] ?? const <ActionType>[];

    return masterActions.map((action) {
      if (alwaysEnabledActions.contains(action.type)) {
        return action.copyWith(isEnabled: true);
      }
      return action.copyWith(isEnabled: allowedActions.contains(action.type));
    }).toList();
  }

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
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Pilih Minimal 1 Item!"));
      return;
    }

    final item = selectedItems.first;
    final cobId = _cobId(context);

    switch (actionType) {
      case ActionType.lacakPolis:
        _navigateToDetail(context, item, onActionComplete);
        break;
      case ActionType.endorse:
        _openEndorse(context, cobId, item, onActionComplete);
        break;
      case ActionType.perpanjangan:
        _openRenewal(context, cobId, item, onActionComplete);
        break;
      case ActionType.aktifkanKembali:
        _openReactive(context, cobId, item, onActionComplete);
        break;
      case ActionType.lihatPolisPar:
        _downloadPar(context, item);
        break;
      case ActionType.lihatPolisEq:
        _downloadEq(context, item);
        break;
      case ActionType.lihatPolis:
        _downloadGeneric(context, cobId, item);
        break;
      default:
        _handleAlwaysEnabled(context, actionType, onActionComplete);
    }
  }

  static String _polisIdFromItem(String cobId, dynamic item) {
    return switch (cobId) {
      "10002" => item.asetParId,
      "10003" => item.asetMvId,
      "10004" => item.asetHullId,
      "10005" => item.asethealthId,
      "10006" => item.asetOthersId,
      _ => "",
    };
  }

  static void _openEndorse(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _openRenewal(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => RenewalFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _openReactive(
      BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final polisId = _polisIdFromItem(cobId, item);
    if (polisId.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => ReaktifFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: polisId,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  static void _downloadGeneric(
      BuildContext c, String cobId, dynamic item) {
    final polisFileId = item.filePolisId;
    if (polisFileId.isEmpty) return;

    final bloc = c.read<SppaDownloadPolisBloc>();

    final cob = switch (cobId) {
      "10003" => "MV",
      "10004" => "HULL",
      "10005" => "HEALTH",
      _ => "",
    };

    bloc.add(DownloadFileEvent(ePolisId: polisFileId, cob: cob));
  }

  static void _downloadPar(BuildContext c, dynamic item) {
    if (item.filePolisParId.isEmpty) return;
    c.read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: item.filePolisParId, cob: 'PAR'));
  }

  static void _downloadEq(BuildContext c, dynamic item) {
    if (item.filePolisEqId.isEmpty) return;
    c.read<SppaDownloadPolisBloc>()
        .add(DownloadFileEvent(ePolisId: item.filePolisEqId, cob: 'PAR'));
  }

  static void _handleAlwaysEnabled(
      BuildContext context, ActionType type, VoidCallback? onComplete) {
    switch (type) {
      case ActionType.beliPolis:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BeliPolisPage()),
        ).then((_) => onComplete?.call());
        break;
      case ActionType.unduhPolis:
        ScaffoldMessenger.of(context)
            .showSnackBar(infoSnackBar("Mengunduh Polis..."));
        onComplete?.call();
        break;
      default:
        break;
    }
  }

  static void _navigateToDetail(
      BuildContext context, dynamic item, VoidCallback? onComplete) {
    final cobId = _cobId(context);
    final statusId = _statusId(context);

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