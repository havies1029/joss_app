import 'package:flutter/material.dart';
import 'package:joss_app/helper/fab_action_helper.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';

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

  // statusId -> action types yang boleh (core business rule)
  static const Map<String, Set<ActionType>> statusIdEnabledMatrix = {
    "10001": {ActionType.endorse},
    "10002": {ActionType.lacakPolis},
    "10003": {ActionType.aktifkanKembali},
    "10004": {ActionType.perpanjangan, ActionType.endorse},
  };

  // cobId -> action types yang boleh tampil (UI relevance)
  static const Map<String, Set<ActionType>> cobAllowedMatrix = {
    "10002": {
      ActionType.beliPolis,
      ActionType.unduhPolis, // kalau kamu masih pakai generic unduh (opsional)
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

  /// Public: compute list action untuk ditampilkan + enabled/disabled
  List<ActionMenuItem> computeActions({
    required String cobId,
    required String statusId,
    required Object? selectedItem,
  }) {
    final allowedByCob = cobAllowedMatrix[cobId] ?? const <ActionType>{ActionType.beliPolis};

    // kalau belum select item: tampilkan yang relevan oleh COB,
    // tapi hanya alwaysEnabled yang enabled.
    if (selectedItem == null) {
      return masterActions
          .where((a) => allowedByCob.contains(a.type))
          .map((a) => a.copyWith(isEnabled: alwaysEnabled.contains(a.type)))
          .toList();
    }

    final allowedByStatus = statusIdEnabledMatrix[statusId] ?? const <ActionType>{};

    // lacak: hanya enable kalau status allow + item valid
    final lacakAllowed = allowedByStatus.contains(ActionType.lacakPolis) && _canLacak(selectedItem);

    final allowedTypes = <ActionType>{
      ...alwaysEnabled,
      ...allowedByStatus.where((t) => t != ActionType.lacakPolis),
      if (lacakAllowed) ActionType.lacakPolis,
    };

    // base actions (dari masterActions) -> hanya yang allowed + allowedByCob
    final base = masterActions
        .where((a) => allowedByCob.contains(a.type) && allowedTypes.contains(a.type))
        .map((a) => a.copyWith(isEnabled: true))
        .toList();

    // polis action khusus (download/lihat) -> diputuskan di policy juga
    if (cobId == "10002") {
      final parId = _filePolisParId(selectedItem);
      final eqId = _filePolisEqId(selectedItem);

      // tampilkan hanya kalau relevan oleh COB
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

    return base;
  }

  /// Defensive gate: kalau ada yang memaksa trigger action yang tidak ditampilkan,
  /// kita bisa cek ulang di executor.
  bool isActionAllowed({
    required String cobId,
    required String statusId,
    required Object? selectedItem,
    required ActionType actionType,
  }) {
    final actions = computeActions(cobId: cobId, statusId: statusId, selectedItem: selectedItem);
    final found = actions.where((a) => a.type == actionType).toList();
    if (found.isEmpty) return false;
    return found.first.isEnabled;
  }
}
