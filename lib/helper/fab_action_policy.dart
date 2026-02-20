import 'package:joss_app/helper/fab_action_helper.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';

class FabActionPolicy {
  // === Inject dari tempat kamu (atau keep static) ===
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

  static const alwaysEnabled = <ActionType>{ActionType.beliPolis};

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
    },
    "10003": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
    },
    "10004": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
    },
    "10005": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
    },
    "10006": {
      ActionType.beliPolis,
      ActionType.unduhPolis,
      ActionType.lacakPolis,
      ActionType.endorse,
      ActionType.perpanjangan,
      ActionType.aktifkanKembali,
      ActionType.lihatPolis,
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
  };

  // ---- helper ambil field dari object atau map ----
  String _getField(Object item, String key) {
    try {
      final dyn = item as dynamic;
      final v = (dyn?.toJson != null) ? null : null; // no-op, just to avoid analyzer noise
      final val = (dyn as dynamic);
      final got = (val as dynamic);
      // akses dynamic: item.key
      final res = (got as dynamic);
      // kita coba via noSuchMethod catch:
      // ignore: unnecessary_cast
      final value = (item as dynamic);
      // ignore: avoid_dynamic_calls
      return ((value as dynamic).__lookup(key) ?? "").toString();
    } catch (_) {
      // fallback map
      if (item is Map) return (item[key] ?? "").toString();
      return "";
    }
  }

  // Karena dart gak punya reflection aman, kita bikin getter manual list yang dipakai:
  String _prosesSource(Object item) {
    try {
      // ignore: avoid_dynamic_calls
      return ((item as dynamic).prosesSource ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["prosesSource"] ?? "").toString();
      return "";
    }
  }

  String _prosesId(Object item) {
    try {
      // ignore: avoid_dynamic_calls
      return ((item as dynamic).prosesId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["prosesId"] ?? "").toString();
      return "";
    }
  }

  bool? _parseBool(dynamic raw) {
    if (raw == null) return null;

    if (raw is bool) return raw;

    if (raw is int) {
      if (raw == 1) return true;
      if (raw == 0) return false;
    }

    if (raw is String) {
      final v = raw.trim().toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }

    return null;
  }

  bool? _isReaktif(Object item) {
    try {
      return _parseBool((item as dynamic).isReaktif);
    } catch (_) {
      if (item is Map) {
        return _parseBool(item["isReaktif"]);
      }
      return null;
    }
  }

  bool? _isRenewal(Object item) {
    try {
      return _parseBool((item as dynamic).isRenewal);
    } catch (_) {
      if (item is Map) {
        return _parseBool(item["isRenewal"]);
      }
      return null;
    }
  }

  String _filePolisId(Object item) {
    try {
      // ignore: avoid_dynamic_calls
      return ((item as dynamic).filePolisId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisId"] ?? "").toString();
      return "";
    }
  }

  String _filePolisParId(Object item) {
    try {
      // ignore: avoid_dynamic_calls
      return ((item as dynamic).filePolisParId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisParId"] ?? "").toString();
      return "";
    }
  }

  String _filePolisEqId(Object item) {
    try {
      // ignore: avoid_dynamic_calls
      return ((item as dynamic).filePolisEqId ?? "").toString();
    } catch (_) {
      if (item is Map) return (item["filePolisEqId"] ?? "").toString();
      return "";
    }
  }

  bool _canLacak(Object item) =>
      _prosesSource(item).isNotEmpty && _prosesId(item).isNotEmpty;

  List<ActionMenuItem> computeActions({
    required String cobId,
    required String statusId,
    required Object? selectedItem,
  }) {
    final allowedByCob = cobAllowedMatrix[cobId] ?? othersCobAllowed;

    if (selectedItem == null) {
      return masterActions
          .where((a) => allowedByCob.contains(a.type))
          .map((a) => a.copyWith(isEnabled: alwaysEnabled.contains(a.type)))
          .toList();
    }

    final reaktifFlag = _isReaktif(selectedItem);
    final renewalFlag = _isRenewal(selectedItem);

    final allowedByStatus = statusIdEnabledMatrix[statusId] ?? const <ActionType>{};

    final lacakAllowed =
        allowedByStatus.contains(ActionType.lacakPolis) && _canLacak(selectedItem);

    final allowedTypes = <ActionType>{
      ...alwaysEnabled,
      ...allowedByStatus.where((t) => t != ActionType.lacakPolis),
      if (lacakAllowed) ActionType.lacakPolis,
    };

    final base = masterActions
        .where((a) => allowedByCob.contains(a.type) && allowedTypes.contains(a.type))
        .map((a) {
      final enabled = switch (a.type) {
        ActionType.aktifkanKembali => (reaktifFlag == true),
        ActionType.perpanjangan => (renewalFlag == true),
        _ => true,
      };
      return a.copyWith(isEnabled: enabled);
    })
        .toList();

    final downloadAllowedByStatus =
    allowedByStatus.contains(ActionType.unduhPolis);

    // ✅ aturan download/lihat:
    // - hanya COB 10002 yang punya Par/Eq
    // - selain itu (termasuk cob aneh / 10006 / dst) pakai filePolisId biasa
    if (downloadAllowedByStatus) {
      if (cobId == "10002") {
        final parId = _filePolisParId(selectedItem);
        final eqId  = _filePolisEqId(selectedItem);

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
