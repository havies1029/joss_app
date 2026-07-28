import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../common/constants.dart';
import '../pages/cari_asuransi/mobile/cari_asuransi_page.dart';
import '../pages/management_polis/mobile/detail_management_page/detail_management_widget.dart';
import '../pages/management_polis/floating_action_menu_widget.dart';
import '../pages/management_polis/mobile/form_button_page/endorse_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/reactive_form_page.dart';
import '../pages/management_polis/mobile/form_button_page/renewal_form_page.dart';
import '../widgets/apptheme/hubungi_cs.dart';
import 'fab_action_policy.dart';

class FabActionExecutor {
  final FabActionPolicy policy;
  const FabActionExecutor(this.policy);

  String _cobId(BuildContext c) => c.read<CobManPolBloc>().state.selectedCOBId;
  String _statusId(BuildContext c) => c.read<StatusAsetCariBloc>().state.selectedStatusId;

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(infoSnackBar(message));
  }

  void _emptyDataSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      errorSnackBar("Maaf data tidak tersedia"),
    );
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

  bool? _readBool(Object item, String field) {
    try {
      final dyn = item as dynamic;
      final raw = switch (field) {
        'isReaktif' => dyn.isReaktif,
        'isRenewal' => dyn.isRenewal,
        _ => null,
      };
      return raw is bool ? raw : null;
    } catch (_) {
      if (item is Map) {
        final raw = item[field];
        return raw is bool ? raw : null;
      }
      return null;
    }
  }

  bool _guardTahapan({
    required BuildContext context,
    required ActionType actionType,
    required Object selectedItem,
  }) {
    bool? flag;

    if (actionType == ActionType.aktifkanKembali) {
      flag = _readBool(selectedItem, 'isReaktif');
      if (flag == true) {
        _snack(context, "Polis sudah pernah diaktivasi sebelumnya.");
        return false;
      }
    }

    if (actionType == ActionType.perpanjangan) {
      flag = _readBool(selectedItem, 'isRenewal');
      if (flag == true) {
        _snack(context, "Polis sudah pernah diperpanjang sebelumnya.");
        return false;
      }
    }

    return true;
  }

  // void run({
  //   required BuildContext context,
  //   required ActionType actionType,
  //   required Object? selectedItem,
  //   VoidCallback? onDone,
  // }) {
  //   final cobId = _cobId(context);
  //   final statusId = _statusId(context);
  //
  //   final allowed = policy.isActionAllowed(
  //     cobId: cobId,
  //     statusId: statusId,
  //     selectedItem: selectedItem,
  //     actionType: actionType,
  //   );
  //
  //   if (!allowed) {
  //     _snack(context, "Aksi tidak tersedia untuk kondisi ini.");
  //     return;
  //   }
  //
  //   if (FabActionPolicy.alwaysEnabled.contains(actionType)) {
  //     _handleAlwaysEnabled(context, actionType, onDone);
  //     return;
  //   }
  //
  //   if (selectedItem == null) {
  //     _snack(context, "Pilih Minimal 1 Item!");
  //     return;
  //   }
  //
  //   if (!_guardTahapan(context: context, actionType: actionType, selectedItem: selectedItem)) {
  //     return;
  //   }
  //
  //   switch (actionType) {
  //     case ActionType.lacakPolis:
  //       _navigateToDetail(context, selectedItem, onDone);
  //       break;
  //
  //     case ActionType.endorse:
  //       _openEndorse(context, cobId, selectedItem, onDone);
  //       break;
  //
  //     case ActionType.perpanjangan:
  //       _openRenewal(context, cobId, selectedItem, onDone);
  //       break;
  //
  //     case ActionType.aktifkanKembali:
  //       _openReactive(context, cobId, selectedItem, onDone);
  //       break;
  //
  //     case ActionType.lihatPolisPar:
  //       _downloadPar(context, selectedItem);
  //       break;
  //
  //     case ActionType.lihatPolisEq:
  //       _downloadEq(context, selectedItem);
  //       break;
  //
  //     case ActionType.lihatPolis:
  //     case ActionType.unduhPolis:
  //       _downloadGeneric(context, cobId, selectedItem);
  //       break;
  //
  //     default:
  //       _handleAlwaysEnabled(context, actionType, onDone);
  //   }
  // }

  void run({
    required BuildContext context,
    required ActionType actionType,
    required Object? selectedItem,
    VoidCallback? onDone,
  }) {
    final cobId = _cobId(context);
    final statusId = _statusId(context);

    if (FabActionPolicy.alwaysEnabled.contains(actionType)) {
      _handleAlwaysEnabled(context, actionType, onDone);
      return;
    }

    if (selectedItem == null) {
      _snack(context, "Pilih Minimal 1 Item!");
      return;
    }

    final isTahapanAction =
        actionType == ActionType.perpanjangan ||
            actionType == ActionType.aktifkanKembali;

    if (isTahapanAction) {
      if (!_guardTahapan(
        context: context,
        actionType: actionType,
        selectedItem: selectedItem,
      )) {
        return;
      }
    }

    if (_isDownloadAction(actionType) &&
        !_hasDownloadFileId(selectedItem, actionType)) {
      _emptyDataSnack(context);
      return;
    }

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

  String _sppa1IdFromItem(String cobId, dynamic item) {
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
    final sppa1Id = _sppa1IdFromItem(cobId, item);
    if (sppa1Id.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => EndorseFormPage(
          viewMode: "tambah",
          recordId: "",
          sppaId: sppa1Id,
          cobId: cobId,
          sppa2Id: "",
        ),
      ),
    ).then((_) => done?.call());
  }

  void _openRenewal(BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final sppa1Id = _sppa1IdFromItem(cobId, item);
    if (sppa1Id.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => RenewalFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppa1Id,
          cobId: cobId,
        ),
      ),
    ).then((_) => done?.call());
  }

  void _openReactive(BuildContext c, String cobId, dynamic item, VoidCallback? done) {
    final sppa1Id = _sppa1IdFromItem(cobId, item);
    if (sppa1Id.isEmpty) return;

    Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => ReaktifFormPage(
          viewMode: "tambah",
          recordId: "",
          polisId: sppa1Id,
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
        builder: (_) => DetailManagementPolisPage(
          data: item,
          cobId: cobId,
          statusId: "F",
        ),
      ),
    ).then((_) => onComplete?.call());
  }

  bool _isDownloadAction(ActionType actionType) {
    return actionType == ActionType.unduhPolis ||
        actionType == ActionType.lihatPolis ||
        actionType == ActionType.lihatPolisPar ||
        actionType == ActionType.lihatPolisEq;
  }

  String _readStringField(dynamic item, String field) {
    try {
      final raw = switch (field) {
        'filePolisId' => item.filePolisId,
        'filePolisParId' => item.filePolisParId,
        'filePolisEqId' => item.filePolisEqId,
        _ => null,
      };
      return (raw ?? "").toString();
    } catch (_) {
      if (item is Map) return (item[field] ?? "").toString();
      return "";
    }
  }

  bool _hasDownloadFileId(
    dynamic item,
    ActionType actionType,
  ) {
    return switch (actionType) {
      ActionType.lihatPolisPar =>
        _readStringField(item, 'filePolisParId').isNotEmpty,
      ActionType.lihatPolisEq =>
        _readStringField(item, 'filePolisEqId').isNotEmpty,
      _ => _readStringField(item, 'filePolisId').isNotEmpty,
    };
  }

  void _downloadGeneric(BuildContext c, String cobId, dynamic item) {
    final polisFileId = _readStringField(item, 'filePolisId');
    if (polisFileId.isEmpty) {
      _emptyDataSnack(c);
      return;
    }

    final bloc = c.read<SppaDownloadPolisBloc>();

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
    final id = _readStringField(item, 'filePolisParId');
    if (id.isEmpty) {
      _emptyDataSnack(c);
      return;
    }

    c.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: id, cob: 'PAR'),
    );
  }

  void _downloadEq(BuildContext c, dynamic item) {
    // ignore: avoid_dynamic_calls
    final id = _readStringField(item, 'filePolisEqId');
    if (id.isEmpty) {
      _emptyDataSnack(c);
      return;
    }

    c.read<SppaDownloadPolisBloc>().add(
      DownloadFileEvent(ePolisId: id, cob: 'EQ'),
    );
  }

  void _handleAlwaysEnabled(BuildContext context, ActionType type, VoidCallback? onComplete) {
    switch (type) {
      case ActionType.beliPolis:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CariAsuransiWidget.page()),
        ).then((_) => onComplete?.call());
        break;
      case ActionType.hubungiJps:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.45),
          builder: (_) {
            return HubungiCs(
              mlayanan1Id: '02',
              onPilihLayanan: (noTelepon) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No telepon: $noTelepon"),
                  ),
                );
                // TODO: arahkan ke chat / page tujuan
                // Navigator.push(context, MaterialPageRoute(builder: (_) => ...));
              },
            );
          },
        );
        break;
      default:
        break;
    }
  }
}
