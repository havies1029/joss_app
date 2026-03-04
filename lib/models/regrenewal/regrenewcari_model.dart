
class RegrenewCariModel {
	bool isUbah;
	String minsuranceId;
	String mrekanId;
	String mstsrenewalId;
	String notePerubahan;
	String regrenew1Id;
	DateTime renewTgl;
	String sppa1Id;
	String insuranceName;

	RegrenewCariModel({required this.isUbah, required this.minsuranceId, 
		required this.mrekanId, required this.mstsrenewalId, 
		required this.notePerubahan, required this.regrenew1Id, 
		required this.renewTgl, required this.sppa1Id, 
		required this.insuranceName});

	factory RegrenewCariModel.fromJson(Map<String, dynamic> data) {
		return RegrenewCariModel(
			isUbah: data['isUbah']??'',
			minsuranceId: data['minsuranceId']??'',
			mrekanId: data['mrekanId']??'',
			mstsrenewalId: data['mstsrenewalId']??'',
			notePerubahan: data['notePerubahan']??'',
			regrenew1Id: data['regrenew1Id']??'',
			renewTgl: DateTime.tryParse(data['renewTgl'].toString())??DateTime.now(),
			sppa1Id: data['sppa1Id']??'',
			insuranceName: data['insuranceName']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'isUbah': isUbah,
		'minsuranceId': minsuranceId,
		'mrekanId': mrekanId,
		'mstsrenewalId': mstsrenewalId,
		'notePerubahan': notePerubahan,
		'regrenew1Id': regrenew1Id,
		'renewTgl': renewTgl.toIso8601String(),
		'sppa1Id': sppa1Id,
		'insuranceName': insuranceName};

}
