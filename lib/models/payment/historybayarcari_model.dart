
class HistorybayarCariModel {
	DateTime invTgl;
	String inv1Id;
	int jmlPolis;
	int nomor;
	String status;
	double totalBayar;
	String stsInvId;

	HistorybayarCariModel({required this.invTgl, required this.inv1Id,
		required this.jmlPolis, required this.nomor,
		required this.status, required this.totalBayar, required this.stsInvId});

	factory HistorybayarCariModel.fromJson(Map<String, dynamic> data) {
		return HistorybayarCariModel(
				invTgl: DateTime.tryParse(data['invTgl'].toString())??DateTime.now(),
				inv1Id: data['inv1Id']??'',
				jmlPolis: int.tryParse(data['jmlPolis'].toString())??0,
				nomor: int.tryParse(data['nomor'].toString())??0,
				status: data['status']??'',
				totalBayar: double.tryParse(data['totalBayar'].toString())??0,
				stsInvId: data['stsInvId']??''
		);

	}

	Map<String, dynamic> toJson() =>
			{'invTgl': invTgl.toIso8601String(),
				'inv1Id': inv1Id,
				'jmlPolis': jmlPolis.toString(),
				'nomor': nomor.toString(),
				'status': status,
				'totalBayar': totalBayar.toString(),
				'stsInvId': stsInvId
			};

}
