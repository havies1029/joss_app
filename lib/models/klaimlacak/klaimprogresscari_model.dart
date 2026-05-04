import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
  
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
          : KlaimProgressNilaiKlaimModel.fromJson(json['nilaiKlaim'] as Map<String, dynamic>),
      jadwalBayar: (json['jadwalBayar'] as List<dynamic>?)
              ?.map((e) => KlaimProgressJadwalBayarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <KlaimProgressJadwalBayarModel>[],
      klaimProgressInfo: json['klaimProgressInfo'] == null
          ? null
          : KlaimProgressInfoModel.fromJson(json['klaimProgressInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'listProgress': listProgress.map((e) => e.toJson()).toList(),
        'nilaiKlaim': nilaiKlaim?.toJson(),
        'jadwalBayar': jadwalBayar.map((e) => e.toJson()).toList(),
        'klaimProgressInfo': klaimProgressInfo?.toJson(),
      };
}


/// Item progress (punyamu) - aku rapikan sedikit untuk fileUrl nullable
class KlaimprogresscariModel {
  final String klaimprogressId;
  final String progressNama;
  final String progressDesc;
  final DateTime? progressTgl;
  final String? fileUrl;
  final String actioncode;

  KlaimprogresscariModel({
    required this.klaimprogressId,
    required this.progressNama,
    required this.progressDesc,
    required this.progressTgl,
    this.fileUrl,
    required this.actioncode,
  });

  factory KlaimprogresscariModel.fromJson(Map<String, dynamic> data) {
    final raw = data['fileUrl']?.toString();
    final trimmed = raw?.trim();
    final fullUrl = (trimmed == null || trimmed.isEmpty)
        ? null
        : (trimmed.startsWith('http')
            ? trimmed
            : '${AppData.apiDomain}$trimmed');

    return KlaimprogresscariModel(
      klaimprogressId: (data['klaimprogressId'] ?? '').toString(),
      progressNama: (data['progressNama'] ?? '').toString(),
      progressDesc: (data['progressDesc'] ?? '').toString(),
      progressTgl: DateTime.tryParse(data['progressTgl']?.toString() ?? ''),
      fileUrl: fullUrl,
      actioncode: (data['actioncode'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'klaimprogressId': klaimprogressId,
        'progressNama': progressNama,
        'progressDesc': progressDesc,
        'progressTgl': progressTgl?.toIso8601String(),
        'fileUrl': fileUrl,
        'actioncode': actioncode,
      };
}

