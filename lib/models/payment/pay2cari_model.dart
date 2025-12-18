
class Pay2CariModel {
	String ar1Id;
	String ar2Id;
	double dnOs;
	int nourut;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	String sppaNoref;
	String sppa1Id;

	Pay2CariModel({required this.ar1Id, required this.ar2Id, 
		required this.dnOs, required this.nourut, 
		required this.periodeAkhir, required this.periodeMulai, 
		required this.sppaNoref, required this.sppa1Id});

	factory Pay2CariModel.fromJson(Map<String, dynamic> data) {
		return Pay2CariModel(
			ar1Id: data['ar1Id']??'',
			ar2Id: data['ar2Id']??'',
			dnOs: double.tryParse(data['dnOs'].toString())??0,
			nourut: int.tryParse(data['nourut'].toString())??0,
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			sppaNoref: data['sppaNoref']??'',
			sppa1Id: data['sppa1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'ar1Id': ar1Id,
		'ar2Id': ar2Id,
		'dnOs': dnOs.toString(),
		'nourut': nourut.toString(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'sppaNoref': sppaNoref,
		'sppa1Id': sppa1Id};

}
