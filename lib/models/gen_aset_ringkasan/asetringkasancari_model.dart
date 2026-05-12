class AsetRingkasanCariModel {
  String asetNama;
  String asetRingkasanId;
  String curr;
  int jmlPolis;
  double nilaiAset;
  double nilaiPremi;
  int noUrut;

  AsetRingkasanCariModel(
      {required this.asetNama,
      required this.asetRingkasanId,
      required this.curr,
      required this.jmlPolis,
      required this.nilaiAset,
      required this.nilaiPremi,
      required this.noUrut});

  factory AsetRingkasanCariModel.fromJson(Map<String, dynamic> data) {
    return AsetRingkasanCariModel(
        asetNama: data['asetNama'] ?? '',
        asetRingkasanId: data['asetRingkasanId'] ?? '',
        curr: data['curr'] ?? '',
        jmlPolis: int.tryParse(data['jmlPolis'].toString()) ?? 0,
        nilaiAset: double.tryParse(data['nilaiAset'].toString()) ?? 0,
        nilaiPremi: double.tryParse(data['nilaiPremi'].toString()) ?? 0,
        noUrut: int.tryParse(data['noUrut'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'asetNama': asetNama,
        'asetRingkasanId': asetRingkasanId,
        'curr': curr,
        'jmlPolis': jmlPolis.toString(),
        'nilaiAset': nilaiAset.toString(),
        'nilaiPremi': nilaiPremi.toString(),
        'noUrut': noUrut.toString()
      };
}
