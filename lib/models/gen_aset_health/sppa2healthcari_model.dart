class Sppa2healthCariModel {
  String nama;
  double premiNet;
  String sppa2healthId;
  double tsi;
  String paketNama;
  String curr;

  bool isEndors;
  Sppa2healthCariModel(
      {required this.nama,
      required this.premiNet,
      required this.paketNama,
      required this.tsi,
      required this.sppa2healthId,
      required this.curr,
      required this.isEndors});

  factory Sppa2healthCariModel.fromJson(Map<String, dynamic> data) {
    return Sppa2healthCariModel(
        nama: data['nama'] ?? '',
        premiNet: double.tryParse(data['premiNet'].toString()) ?? 0,
        sppa2healthId: data['sppa2healthId'] ?? '',
        paketNama: data['paketNama'] ?? '',
        tsi: double.tryParse(data['tsi'].toString()) ?? 0,
        curr: data['curr'] ?? '',
        isEndors: data['isEndors'] == true ||
            data['isEndors'].toString() == '1' ||
            data['isEndors'].toString().toLowerCase() == 'true');
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'premiNet': premiNet.toString(),
        'sppa2healthId': sppa2healthId,
        'paketNama': paketNama,
        'tsi': tsi.toString(),
        'curr': curr,
        'isEndors': isEndors
      };
}
