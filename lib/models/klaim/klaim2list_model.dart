class Klaim2ListModel {
  String keterangan;
  double klaimAmountBaru;
  double klaimAmountLama;
  String klaim1Id;
  String klaim2Id;
  String mstsclaimId;
  DateTime perubahanTgl;
  String statusNama;
  bool hasDone;

  Klaim2ListModel(
      {required this.keterangan,
      required this.klaimAmountBaru,
      required this.klaimAmountLama,
      required this.klaim1Id,
      required this.klaim2Id,
      required this.mstsclaimId,
      required this.perubahanTgl,
      required this.statusNama,
      required this.hasDone});

  factory Klaim2ListModel.fromJson(Map<String, dynamic> data) {
    return Klaim2ListModel(
        keterangan: data['keterangan'] ?? '',
        klaimAmountBaru:
            double.tryParse(data['klaimAmountBaru'].toString()) ?? 0,
        klaimAmountLama:
            double.tryParse(data['klaimAmountLama'].toString()) ?? 0,
        klaim1Id: data['klaim1Id'] ?? '',
        klaim2Id: data['klaim2Id'] ?? '',
        mstsclaimId: data['mstsclaimId'] ?? '',
        perubahanTgl: DateTime.tryParse(data['perubahanTgl'].toString()) ??
            DateTime.now(),
        statusNama: data['statusNama'] ?? '',
        hasDone: data['hasDone'] ?? false,);
  }

  Map<String, dynamic> toJson() => {
        'keterangan': keterangan,
        'klaimAmountBaru': klaimAmountBaru.toString(),
        'klaimAmountLama': klaimAmountLama.toString(),
        'klaim1Id': klaim1Id,
        'klaim2Id': klaim2Id,
        'mstsclaimId': mstsclaimId,
        'perubahanTgl': perubahanTgl.toIso8601String(),
        'statusNama': statusNama,
        'hasDone': hasDone
      };
}
