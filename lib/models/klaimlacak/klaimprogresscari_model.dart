import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_file_model.dart';
  
class KlaimprogressCariResultModel {
  final List<KlaimprogresscariModel> listProgress;
  final KlaimProgressNilaiKlaimModel? nilaiKlaim;
  final List<KlaimProgressJadwalBayarModel> jadwalBayar;
  final KlaimProgressInfoModel? klaimProgressInfo;

  KlaimprogressCariResultModel({
    required this.listProgress,
    required this.nilaiKlaim,
    required this.jadwalBayar,
    this.klaimProgressInfo,
  });

  factory KlaimprogressCariResultModel.fromJson(Map<String, dynamic> json) {
    return KlaimprogressCariResultModel(
      listProgress: (json['listProgress'] as List<dynamic>?)
              ?.map((e) => KlaimprogresscariModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <KlaimprogresscariModel>[],

      nilaiKlaim: json['nilaiKlaim'] == null
          ? null
          : KlaimProgressNilaiKlaimModel.fromJson(
              json['nilaiKlaim'] as Map<String, dynamic>,
            ),

      jadwalBayar: (json['jadwalBayar'] as List<dynamic>?)
              ?.map((e) => KlaimProgressJadwalBayarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <KlaimProgressJadwalBayarModel>[],

      klaimProgressInfo: json['klaimProgressInfo'] == null
          ? null
          : KlaimProgressInfoModel.fromJson(
              json['klaimProgressInfo'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'listProgress': listProgress.map((e) => e.toJson()).toList(),
        'nilaiKlaim': nilaiKlaim?.toJson(),
        'jadwalBayar': jadwalBayar.map((e) => e.toJson()).toList(),
        'klaimProgressInfo': klaimProgressInfo?.toJson(),
      };
}

class KlaimprogresscariModel {
  final String klaimprogressId;
  final String progressNama;
  final String progressDesc;
  final DateTime? progressTgl;
  final String? fileUrl;
  final String actioncode;

  /// Baru: multiple file dari table klaim_progress_file
  final List<KlaimProgressFileModel> listFile;

  KlaimprogresscariModel({
    required this.klaimprogressId,
    required this.progressNama,
    required this.progressDesc,
    required this.progressTgl,
    this.fileUrl,
    required this.actioncode,
    required this.listFile,
  });

  factory KlaimprogresscariModel.fromJson(Map<String, dynamic> data) {
    return KlaimprogresscariModel(
      klaimprogressId: (data['klaimprogressId'] ?? '').toString(),
      progressNama: (data['progressNama'] ?? '').toString(),
      progressDesc: (data['progressDesc'] ?? '').toString(),
      progressTgl: DateTime.tryParse(data['progressTgl']?.toString() ?? ''),
      fileUrl: _buildFullFileUrl(data['fileUrl']),
      actioncode: (data['actioncode'] ?? '').toString(),

      listFile: (data['listFile'] as List<dynamic>?)
              ?.map((e) => KlaimProgressFileModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <KlaimProgressFileModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'klaimprogressId': klaimprogressId,
        'progressNama': progressNama,
        'progressDesc': progressDesc,
        'progressTgl': progressTgl?.toIso8601String(),
        'fileUrl': fileUrl,
        'actioncode': actioncode,
        'listFile': listFile.map((e) => e.toJson()).toList(),
      };
}

String? _buildFullFileUrl(dynamic value) {
  final raw = value?.toString();
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }

  if (trimmed.startsWith('http')) {
    return trimmed;
  }
  return '${AppData.apiDomain}$trimmed';

}