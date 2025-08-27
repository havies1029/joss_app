
class Klaim1ListModel {
	String insuredName;
	String kejadianLokasi;
	DateTime kejadianTgl;
	double klaimAmount;
	String klaim1Id;
	String kursId;
	String lastStsclaimId;
	String minsuranceId;
	String mjenisrugiId;
	String insuranceName;
	String rMATAUANGNAMA;
	String rugiDesc;
	String statusNama;

	Klaim1ListModel({required this.insuredName, required this.kejadianLokasi, 
		required this.kejadianTgl, required this.klaimAmount, 
		required this.klaim1Id, required this.kursId, 
		required this.lastStsclaimId, required this.minsuranceId, 
		required this.mjenisrugiId, required this.insuranceName, 
		required this.rMATAUANGNAMA, required this.rugiDesc, 
		required this.statusNama});

	factory Klaim1ListModel.fromJson(Map<String, dynamic> data) {
		return Klaim1ListModel(
			insuredName: data['insuredName']??'',
			kejadianLokasi: data['kejadianLokasi']??'',
			kejadianTgl: DateTime.tryParse(data['kejadianTgl'].toString())??DateTime.now(),
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaim1Id: data['klaim1Id']??'',
			kursId: data['kursId']??'',
			lastStsclaimId: data['lastStsclaimId']??'',
			minsuranceId: data['minsuranceId']??'',
			mjenisrugiId: data['mjenisrugiId']??'',
			insuranceName: data['insuranceName']??'',
			rMATAUANGNAMA: data['rMATAUANGNAMA']??'',
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
		'kursId': kursId,
		'lastStsclaimId': lastStsclaimId,
		'minsuranceId': minsuranceId,
		'mjenisrugiId': mjenisrugiId,
		'insuranceName': insuranceName,
		'rMATAUANGNAMA': rMATAUANGNAMA,
		'rugiDesc': rugiDesc,
		'statusNama': statusNama};

}
