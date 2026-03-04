
class Endors1ListModel {
	DateTime endorsTgl;
	String endors1Id;
	String insuredNama;
	String mstsendorsId;
	String noteKonfirmasi;
	String notePerubahan;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	double premi;
	String sppa1Id;
	String statusEndors;
	double tsi;

	Endors1ListModel({required this.endorsTgl, required this.endors1Id, 
		required this.insuredNama, required this.mstsendorsId, 
		required this.noteKonfirmasi, required this.notePerubahan, 
		required this.periodeAkhir, required this.periodeMulai, 
		required this.premi, required this.sppa1Id, 
		required this.statusEndors, required this.tsi});

	factory Endors1ListModel.fromJson(Map<String, dynamic> data) {
		return Endors1ListModel(
			endorsTgl: DateTime.tryParse(data['endorsTgl'].toString())??DateTime.now(),
			endors1Id: data['endors1Id']??'',
			insuredNama: data['insuredNama']??'',
			mstsendorsId: data['mstsendorsId']??'',
			noteKonfirmasi: data['noteKonfirmasi']??'',
			notePerubahan: data['notePerubahan']??'',
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			premi: double.tryParse(data['premi'].toString())??0,
			sppa1Id: data['sppa1Id']??'',
			statusEndors: data['statusEndors']??'',
			tsi: double.tryParse(data['tsi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'endorsTgl': endorsTgl.toIso8601String(),
		'endors1Id': endors1Id,
		'insuredNama': insuredNama,
		'mstsendorsId': mstsendorsId,
		'noteKonfirmasi': noteKonfirmasi,
		'notePerubahan': notePerubahan,
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'premi': premi.toString(),
		'sppa1Id': sppa1Id,
		'statusEndors': statusEndors,
		'tsi': tsi.toString()};

}
