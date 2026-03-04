
class RegreaktifCariModel {
	bool isUbah;
	String minsuranceId;
	String mrekanId;
	String mstsreaktifId;
	String notePerubahan;
	DateTime reaktifTgl;
	String regreaktif1Id;
	String sppa1Id;
	String insuranceName;

	RegreaktifCariModel({required this.isUbah, required this.minsuranceId, 
		required this.mrekanId, required this.mstsreaktifId, 
		required this.notePerubahan, required this.reaktifTgl, 
		required this.regreaktif1Id, required this.sppa1Id, 
		required this.insuranceName});

	factory RegreaktifCariModel.fromJson(Map<String, dynamic> data) {
		return RegreaktifCariModel(
			isUbah: data['isUbah']??'',
			minsuranceId: data['minsuranceId']??'',
			mrekanId: data['mrekanId']??'',
			mstsreaktifId: data['mstsreaktifId']??'',
			notePerubahan: data['notePerubahan']??'',
			reaktifTgl: DateTime.tryParse(data['reaktifTgl'].toString())??DateTime.now(),
			regreaktif1Id: data['regreaktif1Id']??'',
			sppa1Id: data['sppa1Id']??'',
			insuranceName: data['insuranceName']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'isUbah': isUbah,
		'minsuranceId': minsuranceId,
		'mrekanId': mrekanId,
		'mstsreaktifId': mstsreaktifId,
		'notePerubahan': notePerubahan,
		'reaktifTgl': reaktifTgl.toIso8601String(),
		'regreaktif1Id': regreaktif1Id,
		'sppa1Id': sppa1Id,
		'insuranceName': insuranceName};

}
