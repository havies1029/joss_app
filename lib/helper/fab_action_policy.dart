import 'package:flutter/cupertino.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';

class FabActionPolicy {
  final List<ActionMenuItem> masterActions;
  final ActionMenuItem downloadPolisItem;
  final ActionMenuItem downloadParItem;
  final ActionMenuItem downloadEqItem;

  FabActionPolicy({
    required this.masterActions,
    required this.downloadPolisItem,
    required this.downloadParItem,
    required this.downloadEqItem,
  });

  static const alwaysEnabled = <ActionType>{
    ActionType.beliPolis,
    ActionType.hubungiJps,
  };

  static const Map<String, Set<ActionType>> statusIdEnabledMatrix = {
    "10001": {ActionType.endorse, ActionType.unduhPolis},
    "10002": {ActionType.lacakPolis, ActionType.unduhPolis},
    "10003": {ActionType.aktifkanKembali},
    "10004": {ActionType.perpanjangan, ActionType.endorse},
  };

  static const Map<String, Set<ActionType>> cobAllowedMatrix = {
    "10002": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolisPar,
      ActionType.lihatPolisEq,
      ActionType.hubungiJps,
    },
    "10003": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
      ActionType.hubungiJps,
    },
    "10004": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
      ActionType.hubungiJps,
    },
    "10005": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
      ActionType.hubungiJps,
    },
    "10006": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
      ActionType.hubungiJps,
    },
  };

  static const Set<ActionType> othersCobAllowed = {
    ActionType.beliPolis,
    ActionType.unduhPolis,
    ActionType.lacakPolis,
    ActionType.endorse,
    ActionType.perpanjangan,
    ActionType.aktifkanKembali,
    ActionType.lihatPolis,
    ActionType.hubungiJps,
  };

  bool _canReaktif(Object item) {
    final raw = _readBool(item, "isReaktif");
    return raw == false;
  }

  bool _canRenewal(Object item) {
    final raw = _readBool(item, "isRenewal");
    return raw == false;
  }

  bool? _readBool(Object item, String key) {
    try {
      final dyn = item as dynamic;
      final raw = switch (key) {
        "isReaktif" => dyn.isReaktif,
        "isRenewal" => dyn.isRenewal,
        _ => null,
      };
      return raw is bool ? raw : null;
    } catch (_) {
      if (item is Map) {
        final raw = item[key];
        return raw is bool ? raw : null;
      }
      return null;
    }
  }

  String _prosesSource(Object item) {
    try {
      return ((item as dynamic).prosesSource ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["prosesSource"] ?? "").toString();
      return "";
    }
  }

  String _prosesId(Object item) {
    try {
      return ((item as dynamic).prosesId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["prosesId"] ?? "").toString();
      return "";
    }
  }

  bool _canLacak(Object item) =>
      _prosesSource(item).isNotEmpty && _prosesId(item).isNotEmpty;

  void _dbg(String msg) => debugPrint(msg);

  void _dbgRenewal({
    required String cobId,
    required String statusId,
    required Object selectedItem,
    required Set<ActionType> allowedByCob,
    required Set<ActionType> allowedByStatus,
    required Set<ActionType> allowedTypes,
    required List<ActionMenuItem> base,
    required bool? renewalFlag,
  }) {
    dynamic rawIsRenewal;
    try {
      rawIsRenewal = (selectedItem as dynamic).isRenewal;
    } catch (_) {
      if (selectedItem is Map) rawIsRenewal = (selectedItem)["isRenewal"];
    }

    final hasRenewalInMaster =
        masterActions.any((a) => a.type == ActionType.perpanjangan);

    _dbg("========== FAB RENEWAL DEBUG ==========");
    _dbg("cobId=$cobId | statusId=$statusId | selectedType=${selectedItem.runtimeType}");
    _dbg("hasRenewalInMaster=$hasRenewalInMaster");
    _dbg("allowedByCob has renewal=${allowedByCob.contains(ActionType.perpanjangan)}");
    _dbg("allowedByStatus=$allowedByStatus");
    _dbg("allowedByStatus has renewal=${allowedByStatus.contains(ActionType.perpanjangan)}");
    _dbg("allowedTypes=$allowedTypes");
    _dbg("allowedTypes has renewal=${allowedTypes.contains(ActionType.perpanjangan)}");
    _dbg("rawIsRenewal=$rawIsRenewal | rawType=${rawIsRenewal.runtimeType}");
    _dbg("parsed renewalFlag=$renewalFlag");
    _dbg("base types=${base.map((e) => e.type).toList()}");
    _dbg("base has renewal=${base.any((e) => e.type == ActionType.perpanjangan)}");
    _dbg("======================================");
  }

  List<ActionMenuItem> computeActions({
    required String cobId,
    required String statusId,
    required Object? selectedItem,
  }) {
    final allowedByCob = cobAllowedMatrix[cobId] ?? othersCobAllowed;

    // belum pilih item => tampilkan menu sesuai COB, tapi semua disabled
    if (selectedItem == null) {
      return masterActions
          .where((a) => allowedByCob.contains(a.type))
          .map(
            (a) => a.copyWith(
              isEnabled: a.type == ActionType.beliPolis ||
                  a.type == ActionType.hubungiJps,
            ),
          )
          .toList();
    }

    final canReaktif = _canReaktif(selectedItem);
    final canRenewal = _canRenewal(selectedItem);

    final allowedByStatus =
        statusIdEnabledMatrix[statusId] ?? const <ActionType>{};

    final lacakAllowed =
        allowedByStatus.contains(ActionType.lacakPolis) &&
            _canLacak(selectedItem);

    final allowedTypes = <ActionType>{
      ...alwaysEnabled,
      ...allowedByStatus.where((t) => t != ActionType.lacakPolis),
      if (lacakAllowed) ActionType.lacakPolis,
    };

    final base = masterActions
        .where((a) => allowedByCob.contains(a.type) && allowedTypes.contains(a.type))
        .map((a) {
      final enabled = switch (a.type) {
        ActionType.aktifkanKembali => canReaktif,
        ActionType.perpanjangan => canRenewal,
        _ => true,
      };
      return a.copyWith(isEnabled: enabled);
    }).toList();

    _dbgRenewal(
      cobId: cobId,
      statusId: statusId,
      selectedItem: selectedItem,
      allowedByCob: allowedByCob,
      allowedByStatus: allowedByStatus,
      allowedTypes: allowedTypes,
      base: base,
      renewalFlag: canRenewal,
    );

    final downloadAllowedByStatus =
        allowedByStatus.contains(ActionType.unduhPolis);

    if (downloadAllowedByStatus) {
      if (cobId == "10002") {
        final parId = _filePolisParId(selectedItem);
        final eqId = _filePolisEqId(selectedItem);

        if (allowedByCob.contains(ActionType.lihatPolisPar)) {
          base.add(downloadParItem.copyWith(isEnabled: parId.isNotEmpty));
        }
        if (allowedByCob.contains(ActionType.lihatPolisEq)) {
          base.add(downloadEqItem.copyWith(isEnabled: eqId.isNotEmpty));
        }
      } else {
        final fileId = _filePolisId(selectedItem);
        if (allowedByCob.contains(ActionType.lihatPolis)) {
          base.add(downloadPolisItem.copyWith(isEnabled: fileId.isNotEmpty));
        }
      }
    }

    return base;
  }

  String _filePolisId(Object item) {
    try {
      return ((item as dynamic).filePolisId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisId"] ?? "").toString();
      return "";
    }
  }

  String _filePolisParId(Object item) {
    try {
      return ((item as dynamic).filePolisParId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisParId"] ?? "").toString();
      return "";
    }
  }

  String _filePolisEqId(Object item) {
    try {
      return ((item as dynamic).filePolisEqId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisEqId"] ?? "").toString();
      return "";
    }
  }

  bool isActionAllowed({
    required String cobId,
    required String statusId,
    required Object? selectedItem,
    required ActionType actionType,
  }) {
    final actions =
        computeActions(cobId: cobId, statusId: statusId, selectedItem: selectedItem);
    final found = actions.where((a) => a.type == actionType).toList();
    if (found.isEmpty) return false;
    return found.first.isEnabled;
  }
}