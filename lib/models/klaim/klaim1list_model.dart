
class Klaim1ListModel {
	String insuredName;
	String kejadianLokasi;
	DateTime kejadianTgl;
	double klaimAmount;
	String klaim1Id;
	String insuranceName;
	String currDesc;
	String rugiDesc;
	String statusNama;

	Klaim1ListModel({required this.insuredName, required this.kejadianLokasi, 
		required this.kejadianTgl, required this.klaimAmount, 
		required this.klaim1Id, required this.insuranceName, 
		required this.currDesc, required this.rugiDesc, 
		required this.statusNama});

	factory Klaim1ListModel.fromJson(Map<String, dynamic> data) {
		return Klaim1ListModel(
			insuredName: data['insuredName']??'',
			kejadianLokasi: data['kejadianLokasi']??'',
			kejadianTgl: DateTime.tryParse(data['kejadianTgl'].toString())??DateTime.now(),
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaim1Id: data['klaim1Id']??'',
			insuranceName: data['insuranceName']??'',
			currDesc: data['currDesc']??'',
			rugiDesc: data['rugiDesc']??'',
			statusNama: data['statusNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'insuredName': insuredName,
		'kejadianLokasi': kejadianLokasi,
		'kejadianTgl': kejadianTgl.toIso8601String(),
		'klaimAmount': klaimAmount.toString(),
		'klaim1Id': klaim1Id,
		'insuranceName': insuranceName,
		'currDesc': currDesc,
		'rugiDesc': rugiDesc,
		'statusNama': statusNama};

}
