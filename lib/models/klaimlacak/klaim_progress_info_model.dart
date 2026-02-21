class KlaimProgressInfoModel {
  final String? metodeKlaimId;
  final String groupStatusId;
  final String klaimNilaiId;

  KlaimProgressInfoModel({this.metodeKlaimId, required this.groupStatusId, required this.klaimNilaiId});

  factory KlaimProgressInfoModel.fromJson(Map<String, dynamic> json) {
    return KlaimProgressInfoModel(
      metodeKlaimId: json['metodeKlaimId']?.toString(),
      groupStatusId: json['groupStatusId']?.toString() ?? '',
      klaimNilaiId: json['klaimNilaiId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'metodeKlaimId': metodeKlaimId,
        'groupStatusId': groupStatusId,
        'klaimNilaiId': klaimNilaiId,
      };
}
