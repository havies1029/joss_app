
class AsettrackCariModel {
	int nomor;
	String polisiNo;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	String sppa1Id;
	String sppa2mvId;

	AsettrackCariModel({required this.nomor, required this.polisiNo, 
		required this.prosesId, required this.prosesRemarks, 
		required this.prosesSource, required this.sppa1Id, 
		required this.sppa2mvId});

	factory AsettrackCariModel.fromJson(Map<String, dynamic> data) {
		return AsettrackCariModel(
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisiNo: data['polisiNo']??'',
			prosesId: data['prosesId']??'',
			prosesRemarks: data['prosesRemarks']??'',
			prosesSource: data['prosesSource']??'',
			sppa1Id: data['sppa1Id']??'',
			sppa2mvId: data['sppa2mvId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'nomor': nomor.toString(),
		'polisiNo': polisiNo,
		'prosesId': prosesId,
		'prosesRemarks': prosesRemarks,
		'prosesSource': prosesSource,
		'sppa1Id': sppa1Id,
		'sppa2mvId': sppa2mvId};

}
