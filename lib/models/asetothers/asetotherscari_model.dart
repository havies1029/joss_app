
class AsetothersCariModel {
	String asetOthersId;
	String curr;
	int nomor;
	String objectDesc;
	String polisNo;
	double premi;
	String status;
	double sumInsured;
	String filePolisId;

	AsetothersCariModel({required this.asetOthersId, required this.curr,
		required this.nomor, required this.objectDesc,
		required this.polisNo, required this.premi,
		required this.status, required this.sumInsured, required this.filePolisId});

	factory AsetothersCariModel.fromJson(Map<String, dynamic> data) {
		return AsetothersCariModel(
			asetOthersId: data['asetOthersId']??'',
			curr: data['curr']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			objectDesc: data['objectDesc']??'',
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			status: data['status']??'',
			sumInsured: double.tryParse(data['sumInsured'].toString())??0,
			filePolisId: data['filePolisId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
			{'asetOthersId': asetOthersId,
				'curr': curr,
				'nomor': nomor.toString(),
				'objectDesc': objectDesc,
				'polisNo': polisNo,
				'premi': premi.toString(),
				'status': status,
				'sumInsured': sumInsured.toString(),
				'filePolisId': filePolisId,
			};

}
