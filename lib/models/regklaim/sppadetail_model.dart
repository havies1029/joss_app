
class SppaDetailModel {
	DateTime periodeAkhir;
	DateTime periodeMulai;
	String polisNo;
	String sppa1Id;
	String stsLunas;

	SppaDetailModel({required this.periodeAkhir, required this.periodeMulai, 
		required this.polisNo, required this.sppa1Id, 
		required this.stsLunas});

	factory SppaDetailModel.fromJson(Map<String, dynamic> data) {
		return SppaDetailModel(
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			polisNo: data['polisNo']??'',
			sppa1Id: data['sppa1Id']??'',
			stsLunas: data['stsLunas']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'polisNo': polisNo,
		'sppa1Id': sppa1Id,
		'stsLunas': stsLunas};

}
