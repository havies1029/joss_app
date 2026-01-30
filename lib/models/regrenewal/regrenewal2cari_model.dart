
class Regrenewal2CariModel {
	String mprogressrenewalId;
	String regrenew1Id;
	String regrenew2Id;
	String remaks;
	DateTime tglStatus;

	Regrenewal2CariModel({required this.mprogressrenewalId, required this.regrenew1Id, 
		required this.regrenew2Id, required this.remaks, 
		required this.tglStatus});

	factory Regrenewal2CariModel.fromJson(Map<String, dynamic> data) {
		return Regrenewal2CariModel(
			mprogressrenewalId: data['mprogressrenewalId']??'',
			regrenew1Id: data['regrenew1Id']??'',
			regrenew2Id: data['regrenew2Id']??'',
			remaks: data['remaks']??'',
			tglStatus: DateTime.tryParse(data['tglStatus'].toString())??DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
		{'mprogressrenewalId': mprogressrenewalId,
		'regrenew1Id': regrenew1Id,
		'regrenew2Id': regrenew2Id,
		'remaks': remaks,
		'tglStatus': tglStatus.toIso8601String()};

}
