
class MRekanPicListModel {
	bool isDefault;
	String mjabatanId;
	String mrekan1Id;
	String mrekanpicId;
	String picEmail;
	String picHp;
	String picNama;
	String jabatanDesc;

	MRekanPicListModel({required this.isDefault, required this.mjabatanId,
		required this.mrekan1Id, required this.mrekanpicId,
		required this.picEmail, required this.picHp,
		required this.picNama, required this.jabatanDesc});

	factory MRekanPicListModel.fromJson(Map<String, dynamic> data) {
		return MRekanPicListModel(
				isDefault: data['isDefault']??false,
				mjabatanId: data['mjabatanId']??'',
				mrekan1Id: data['mrekan1Id']??'',
				mrekanpicId: data['mrekanpicId']??'',
				picEmail: data['picEmail']??'',
				picHp: data['picHp']??'',
				picNama: data['picNama']??'',
				jabatanDesc: data['jabatanDesc']??''
		);

	}

	Map<String, dynamic> toJson() =>
			{'isDefault': isDefault,
				'mjabatanId': mjabatanId,
				'mrekan1Id': mrekan1Id,
				'mrekanpicId': mrekanpicId,
				'picEmail': picEmail,
				'picHp': picHp,
				'picNama': picNama,
				'jabatanDesc': jabatanDesc};

}
