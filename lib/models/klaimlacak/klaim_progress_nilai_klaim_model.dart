
class KlaimProgressNilaiKlaimModel {
  final String curr;
  final double klaimAmount;

  KlaimProgressNilaiKlaimModel({
    required this.curr,
    required this.klaimAmount,
  });

  factory KlaimProgressNilaiKlaimModel.fromJson(Map<String, dynamic> json) {
    return KlaimProgressNilaiKlaimModel(
      curr: (json['curr'] ?? '').toString(),
      klaimAmount: (json['klaimAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'curr': curr,
        'klaimAmount': klaimAmount,
      };
}
