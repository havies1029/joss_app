class KlaimProgressJadwalBayarModel {
  final String penanggung;
  final double sharePersen;
  final String curr;
  final double nilaiBayar;
  final DateTime? jadwalBayar;
  final String metodeBayar;

  KlaimProgressJadwalBayarModel({
    required this.penanggung,
    required this.sharePersen,
    required this.curr,
    required this.nilaiBayar,
    required this.jadwalBayar,
    required this.metodeBayar,
  });

  factory KlaimProgressJadwalBayarModel.fromJson(
      Map<String, dynamic> json,
      ) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return KlaimProgressJadwalBayarModel(
      penanggung: (json['penanggung'] ?? '').toString(),
      sharePersen: (json['sharePersen'] as num?)?.toDouble() ?? 0.0,
      curr: (json['curr'] ?? '').toString(),
      nilaiBayar: (json['nilaiBayar'] as num?)?.toDouble() ?? 0.0,
      jadwalBayar: parseDate(json['jadwalBayar']),
      metodeBayar: (json['metodeBayar'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'penanggung': penanggung,
    'sharePersen': sharePersen,
    'curr': curr,
    'nilaiBayar': nilaiBayar,
    'jadwalBayar': jadwalBayar?.toIso8601String(),
    'metodeBayar': metodeBayar,
  };
}