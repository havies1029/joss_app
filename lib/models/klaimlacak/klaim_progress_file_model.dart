import 'package:joss_app/common/app_data.dart';

class KlaimProgressFileModel {
  final String klaimprogressfileId;
  final String klaimprogressId;
  final String keterangan;
  final int? noUrut;
  final String? fileUrl;

  KlaimProgressFileModel({
    required this.klaimprogressfileId,
    required this.klaimprogressId,
    required this.keterangan,
    this.noUrut,
    this.fileUrl,
  });

  factory KlaimProgressFileModel.fromJson(Map<String, dynamic> data) {
    return KlaimProgressFileModel(
      klaimprogressfileId: (data['klaimprogressfileId'] ?? '').toString(),
      klaimprogressId: (data['klaimprogressId'] ?? '').toString(),
      keterangan: (data['keterangan'] ?? '').toString(),
      noUrut: _toNullableInt(data['noUrut']),
      fileUrl: _buildFullFileUrl(data['fileUrl']),
    );

  }

  Map<String, dynamic> toJson() => {
        'klaimprogressfileId': klaimprogressfileId,
        'klaimprogressId': klaimprogressId,
        'keterangan': keterangan,
        'noUrut': noUrut,
        'fileUrl': fileUrl,
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

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());

}