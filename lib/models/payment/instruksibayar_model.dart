class InstruksiBayarModel {
  int urutan;
  String tahapDesc;
  String nomor;

  InstruksiBayarModel({
    required this.urutan,
    required this.tahapDesc,
    this.nomor = '',
  });

  factory InstruksiBayarModel.fromJson(Map<String, dynamic> json) {
    return InstruksiBayarModel(
      urutan: json['urutan'] ?? 0,
      tahapDesc: json['tahapDesc'] ?? '',
      nomor: json['nomor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'urutan': urutan,
        'tahapDesc': tahapDesc,
        'nomor': nomor,
      };
}
