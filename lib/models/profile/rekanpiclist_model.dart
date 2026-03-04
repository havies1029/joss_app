
class RekanPicListModel {
	int isDefault;
	String mjabatanId;
	String mrekan1Id;
	String mrekanpicId;
	String picEmail;
	String picHp;
	String picNama;

	RekanPicListModel({required this.isDefault, required this.mjabatanId, 
		required this.mrekan1Id, required this.mrekanpicId, 
		required this.picEmail, required this.picHp, 
		required this.picNama});

	factory RekanPicListModel.fromJson(Map<String, dynamic> data) {
		return RekanPicListModel(
			isDefault: int.tryParse(data['isDefault'].toString())??0,
			mjabatanId: data['mjabatanId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			mrekanpicId: data['mrekanpicId']??'',
			picEmail: data['picEmail']??'',
			picHp: data['picHp']??'',
			picNama: data['picNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'isDefault': isDefault.toString(),
		'mjabatanId': mjabatanId,
		'mrekan1Id': mrekan1Id,
		'mrekanpicId': mrekanpicId,
		'picEmail': picEmail,
		'picHp': picHp,
		'picNama': picNama};

}
