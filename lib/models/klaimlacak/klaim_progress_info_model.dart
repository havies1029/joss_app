class KlaimProgressInfoModel {
  final String groupStatusId;
  final String klaimNilaiId;

  KlaimProgressInfoModel({required this.groupStatusId, required this.klaimNilaiId});

  factory KlaimProgressInfoModel.fromJson(Map<String, dynamic> json) {
    return KlaimProgressInfoModel(
      groupStatusId: json['groupStatusId']?.toString() ?? '',
      klaimNilaiId: json['klaimNilaiId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'groupStatusId': groupStatusId,
        'klaimNilaiId': klaimNilaiId,
      };
}
