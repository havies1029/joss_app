class AsetRingkasanCariModel {
  String asetNama;
  String asetRingkasanId;
  String curr;
  int jmlAset;
  double nilaiAset;
  double nilaiPremi;
  int noUrut;
  String satuan;

  AsetRingkasanCariModel(
      {required this.asetNama,
      required this.asetRingkasanId,
      required this.curr,
      required this.jmlAset,
      required this.nilaiAset,
      required this.nilaiPremi,
      required this.noUrut,
      required this.satuan});

  factory AsetRingkasanCariModel.fromJson(Map<String, dynamic> data) {
    return AsetRingkasanCariModel(
        asetNama: data['asetNama'] ?? '',
        asetRingkasanId: data['asetRingkasanId'] ?? '',
        curr: data['curr'] ?? '',
        jmlAset: int.tryParse(data['jmlAset'].toString()) ?? 0,
        nilaiAset: double.tryParse(data['nilaiAset'].toString()) ?? 0,
        nilaiPremi: double.tryParse(data['nilaiPremi'].toString()) ?? 0,
        noUrut: int.tryParse(data['noUrut'].toString()) ?? 0,
        satuan: data['satuan'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'asetNama': asetNama,
        'asetRingkasanId': asetRingkasanId,
        'curr': curr,
        'jmlAset': jmlAset.toString(),
        'nilaiAset': nilaiAset.toString(),
        'nilaiPremi': nilaiPremi.toString(),
        'noUrut': noUrut.toString(),
        'satuan': satuan
      };
}
