class InstruksiBayarModel {
  int urutan;
  String tahapDesc;

  InstruksiBayarModel({
    required this.urutan,
    required this.tahapDesc,
  });

  factory InstruksiBayarModel.fromJson(Map<String, dynamic> json) {
    return InstruksiBayarModel(
      urutan: json['urutan'] ?? 0,
      tahapDesc: json['tahapDesc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'urutan': urutan,
        'tahapDesc': tahapDesc,
      };
}
