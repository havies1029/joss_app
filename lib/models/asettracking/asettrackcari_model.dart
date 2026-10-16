class AsettrackCariModel {
  int nomor;
  String polisiNo;
  String prosesId;
  String prosesRemarks;
  String prosesSource;
  String polis1Id;
  String polis2mvId;

  // Alias transisi untuk consumer respons lama.
  String get sppa1Id => polis1Id;

  // Alias transisi untuk consumer respons lama.
  String get sppa2mvId => polis2mvId;

  AsettrackCariModel(
      {required this.nomor,
      required this.polisiNo,
      required this.prosesId,
      required this.prosesRemarks,
      required this.prosesSource,
      required this.polis1Id,
      required this.polis2mvId});

  factory AsettrackCariModel.fromJson(Map<String, dynamic> data) {
    return AsettrackCariModel(
        nomor: int.tryParse(data['nomor'].toString()) ?? 0,
        polisiNo: data['polisiNo'] ?? '',
        prosesId: data['prosesId'] ?? '',
        prosesRemarks: data['prosesRemarks'] ?? '',
        prosesSource: data['prosesSource'] ?? '',
        polis1Id: (data['polis1Id'] ?? data['sppa1Id'] ?? '').toString(),
        polis2mvId: (data['polis2mvId'] ?? data['sppa2mvId'] ?? '').toString());
  }

  Map<String, dynamic> toJson() => {
        'nomor': nomor.toString(),
        'polisiNo': polisiNo,
        'prosesId': prosesId,
        'prosesRemarks': prosesRemarks,
        'prosesSource': prosesSource,
        'polis1Id': polis1Id,
        'polis2mvId': polis2mvId
      };
}
