
class RegendorsCariModel {
	DateTime endorsTgl;
	String minsuranceId;
	String mrekanId;
	String mstsendorsId;
	String notePerubahan;
	String regendors1Id;
	String sppa1Id;
	String insuranceName;

	RegendorsCariModel({required this.endorsTgl, required this.minsuranceId, 
		required this.mrekanId, required this.mstsendorsId, 
		required this.notePerubahan, required this.regendors1Id, 
		required this.sppa1Id, required this.insuranceName});

	factory RegendorsCariModel.fromJson(Map<String, dynamic> data) {
		return RegendorsCariModel(
			endorsTgl: DateTime.tryParse(data['endorsTgl'].toString())??DateTime.now(),
			minsuranceId: data['minsuranceId']??'',
			mrekanId: data['mrekanId']??'',
			mstsendorsId: data['mstsendorsId']??'',
			notePerubahan: data['notePerubahan']??'',
			regendors1Id: data['regendors1Id']??'',
			sppa1Id: data['sppa1Id']??'',
			insuranceName: data['insuranceName']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'endorsTgl': endorsTgl.toIso8601String(),
		'minsuranceId': minsuranceId,
		'mrekanId': mrekanId,
		'mstsendorsId': mstsendorsId,
		'notePerubahan': notePerubahan,
		'regendors1Id': regendors1Id,
		'sppa1Id': sppa1Id,
		'insuranceName': insuranceName};

}
