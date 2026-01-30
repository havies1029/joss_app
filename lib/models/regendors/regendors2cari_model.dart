
class Regendors2CariModel {
	String mprogressendorsId;
	String regendors1Id;
	String regendors2Id;
	String remarks;
	DateTime tglStatus;

	Regendors2CariModel({required this.mprogressendorsId, required this.regendors1Id, 
		required this.regendors2Id, required this.remarks, 
		required this.tglStatus});

	factory Regendors2CariModel.fromJson(Map<String, dynamic> data) {
		return Regendors2CariModel(
			mprogressendorsId: data['mprogressendorsId']??'',
			regendors1Id: data['regendors1Id']??'',
			regendors2Id: data['regendors2Id']??'',
			remarks: data['remarks']??'',
			tglStatus: DateTime.tryParse(data['tglStatus'].toString())??DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
		{'mprogressendorsId': mprogressendorsId,
		'regendors1Id': regendors1Id,
		'regendors2Id': regendors2Id,
		'remarks': remarks,
		'tglStatus': tglStatus.toIso8601String()};

}
