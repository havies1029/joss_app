
class Historybayar2CariModel {
	String curr;
	String dn1Id;
	double nilaiBayar;
	String polisNo;
	String sppa1Id;
	DateTime periodeMulai;
	DateTime periodeAkhir;

	Historybayar2CariModel({required this.curr, required this.dn1Id,
		required this.nilaiBayar, required this.polisNo,
		required this.sppa1Id, required this.periodeMulai, required this.periodeAkhir});

	factory Historybayar2CariModel.fromJson(Map<String, dynamic> data) {
		return Historybayar2CariModel(
				curr: data['curr']??'',
				dn1Id: data['dn1Id']??'',
				nilaiBayar: double.tryParse(data['nilaiBayar'].toString())??0,
				polisNo: data['polisNo']??'',
				sppa1Id: data['sppa1Id']??'',
				periodeMulai: DateTime.tryParse(data['periodeMulai'] ?? '') ?? DateTime.now(),
				periodeAkhir: DateTime.tryParse(data['periodeAkhir'] ?? '') ?? DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
			{'curr': curr,
				'dn1Id': dn1Id,
				'nilaiBayar': nilaiBayar.toString(),
				'polisNo': polisNo,
				'sppa1Id': sppa1Id,
				'periodeMulai': periodeMulai.toIso8601String(),
				'periodeAkhir': periodeAkhir.toIso8601String()
			};

}
