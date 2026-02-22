import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
// kalau snackBar/helper lain ada di sini
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../common/constants.dart';
import '../pages/beli_polis/mobile/beli_polis_page.dart';
import '../pages/management_polis/detail_management_page/detail_management_widget_2.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import '../pages/management_polis/mobile/form_button_page/endorse_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/reactive_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/renewal_form_page.dart';
import 'fab_action_policy.dart';

// import page & bloc download kamu sesuai project
// import '.../endorse_form_page.dart';
// import '.../renewal_form_page.dart';
// import '.../reaktif_form_page.dart';
// import '.../detail_management_polis_page.dart';
// import '.../beli_polis_page.dart';
// import '.../sppa_download_polis_bloc.dart';
class FabActionExecutor {
  final FabActionPolicy policy;
  const FabActionExecutor(this.policy);

  String _cobId(BuildContext c) => c.read<CobManPolBloc>().state.selectedCOBId;
  String _statusId(BuildContext c) => c.read<StatusAsetCariBloc>().state.selectedStatusId;

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(infoSnackBar(message));
  }

  bool? _boolFlag(Object item, String field) {
    try {
      final dyn = item as dynamic;
      final raw = switch (field) {
        'isReaktif' => dyn.isReaktif,
        'isRenewal' => dyn.isRenewal,
        _ => null,
      };

      if (raw == null) return null;
      if (raw is bool) return raw;
      return raw.toString().toLowerCase() == 'true';
    } catch (_) {
      if (item is Map) {
        final raw = item[field];
        if (raw == null) return null;
        if (raw is bool) return raw;
        return raw.toString().toLowerCase() == 'true';
      }
      return null;
    }
  }

  bool _guardTahapan({
    required BuildContext context,
    required ActionType actionType,
    required Object selectedItem,
  }) {
    if (actionType == ActionType.aktifkanKembali) {
      final flag = _boolFlag(selectedItem, 'isReaktif');
      if (flag == false) {
        _snack(context, "Maaf polis ini sudah memiliki tahapan.");
        return false;
      }
    }

    if (actionType == ActionType.perpanjangan) {
      final flag = _boolFlag(selectedItem, 'isRenewal');
      if (flag == false) {
        _snack(context, "Maaf polis ini sudah memiliki tahapan.");
        return false;
      }
    }

    return true;
  }

  void run({
    required BuildContext context,
    required ActionType actionType,
    required Object? selectedItem,
    VoidCallback? onDone,
  }) {
    final cobId = _cobId(context);
    final statusId = _statusId(context);

    final allowed = policy.isActionAllowed(
      cobId: cobId,
      statusId: statusId,
      selectedItem: selectedItem,
      actionType: actionType,
    );

    if (!allowed) {
      _snack(context, "Aksi tidak tersedia untuk kondisi ini.");
      return;
    }

    if (FabActionPolicy.alwaysEnabled.contains(actionType)) {
      _handleAlwaysEnabled(context, actionType, onDone);
      return;
    }

    if (selectedItem == null) {
      _snack(context, "Pilih Minimal 1 Item!");
      return;
    }

    if (!_guardTahapan(context: context, actionType: actionType, selectedItem: selectedItem)) {
      return;
    }

    switch (actionType) {
      case ActionType.lacakPolis:
        _navigateToDetail(context, selectedItem, onDone);
        break;

      case ActionType.endorse:
        _openEndorse(context, cobId, selectedItem, onDone);
        break;

      case ActionType.perpanjangan:
        _openRenewal(context, cobId, selectedItem, onDone);
        break;

      case ActionType.aktifkanKembali:
        _openReactive(context, cobId, selectedItem, onDone);
        break;

      case ActionType.lihatPolisPar:
        _downloadPar(context, selectedItem);
        break;

      case ActionType.lihatPolisEq:
        _downloadEq(context, selectedItem);
        break;

      case ActionType.lihatPolis:
      case ActionType.unduhPolis:
        _downloadGeneric(context, cobId, selectedItem);
        break;

      default:
        _handleAlwaysEnabled(context, actionType, onDone);
    }
  }

  // Karena kita gak pakai reflection beneran, kita ambil spesifik:
  // ✅ selain 10002-10005 => others (asetOthersId)
  String _polisIdFromItem(String cobId, dynamic item) {
    try {
      // ignore: avoid_dynamic_calls
      return switch (cobId) {
        "10002" => (item.asetParId ?? "").toString(),
        "10003" => (item.asetMvId ?? "").toString(),
        "10004" => (item.asetHullId ?? "").toString(),
        "10005" => (item.asethealthId ?? "").toString(),
        _ => (item.asetOthersId ?? "").toString(),
      };
    } catch (_) {
      if (item is Map) {
        return switch (cobId) {
          "10002" => (item["asetParId"] ?? "").toString(),
          "10003" => (item["asetMvId"] ?? "").toString(),
          "10004" => (item["asetHullId"] ?? "").toString(),
          "10005" => (item["asethealthId"] ?? "").toString(),
          _ => (item["asetOthersId"] ?? "").toString(),
        };
      }
      return "";
    }
  }

  void _openEndorse(BuildContext c, String cobId, dynamic item, VoidCallback? done) {
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

  void _openRenewal(BuildContext c, String cobId, dynamic item, VoidCallback? done) {
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

  void _openReactive(BuildContext c, String cobId, dynamic item, VoidCallback? done) {
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

  void _navigateToDetail(BuildContext context, dynamic item, VoidCallback? onComplete) {
    final cobId = _cobId(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailManagementPolisPage2(
          data: item,
          cobId: cobId,
          statusId: "",
        ),
      ),
    ).then((_) => onComplete?.call());
  }

  void _downloadGeneric(BuildContext c, String cobId, dynamic item) {
    // ignore: avoid_dynamic_calls
    final polisFileId = (item.filePolisId ?? "").toString();
    if (polisFileId.isEmpty) return;

    final bloc = c.read<SppaDownloadPolisBloc>();

    // ✅ selain 10003-10005 => OTHERS (default)
    final cob = switch (cobId) {
      "10003" => "MV",
      "10004" => "HULL",
      "10005" => "HEALTH",
      _ => "OTHERS",
    };

    bloc.add(DownloadFileEvent(ePolisId: polisFileId, cob: cob));
  }

  void _downloadPar(BuildContext c, dynamic item) {
    // ignore: avoid_dynamic_calls
    final id = (item.filePolisParId ?? "").toString();
    if (id.isEmpty) return;

    c.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: id, cob: 'PAR'),
    );
  }

  void _downloadEq(BuildContext c, dynamic item) {
    // ignore: avoid_dynamic_calls
    final id = (item.filePolisEqId ?? "").toString();
    if (id.isEmpty) return;

    c.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: id, cob: 'EQ'),
    );
  }

  void _handleAlwaysEnabled(BuildContext context, ActionType type, VoidCallback? onComplete) {
    switch (type) {
      case ActionType.beliPolis:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BeliPolisPage()),
        ).then((_) => onComplete?.call());
        break;
      default:
        break;
    }
  }
}
