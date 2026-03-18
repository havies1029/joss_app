class MRekanPicListModel {
	bool isDefault;
	String mjabatanId;
	String mrekan1Id;
	String mrekanpicId;
	String picEmail;
	String picHp;
	String picNama;
	String jabatanNama;
	String peranan;
	String listCob;
	String alamat1;
	String? alamat2;
	String? statusPic;

	MRekanPicListModel({
		required this.isDefault,
		required this.mjabatanId,
		required this.mrekan1Id,
		required this.mrekanpicId,
		required this.picEmail,
		required this.picHp,
		required this.picNama,
		required this.jabatanNama,
		required this.peranan,
		required this.listCob,
		required this.alamat1,
		this.alamat2,
		this.statusPic,
	});

	factory MRekanPicListModel.fromJson(Map<String, dynamic> data) {
		return MRekanPicListModel(
			isDefault: data['isDefault'] ?? false,
			mjabatanId: data['mjabatanId'] ?? '',
			mrekan1Id: data['mrekan1Id'] ?? '',
			mrekanpicId: data['mrekanpicId'] ?? '',
			picEmail: data['picEmail'] ?? '',
			picHp: data['picHp'] ?? '',
			picNama: data['picNama'] ?? '',
			jabatanNama: data['jabatanNama'] ?? '',
			peranan: data['peranan'] ?? '',
			listCob: data['listCob'] ?? '',
			alamat1: data['alamat1'] ?? '',
			alamat2: data['alamat2'], // optional
			statusPic: data['statusPic'],
		);
	}

	Map<String, dynamic> toJson() => {
		'isDefault': isDefault,
		'mjabatanId': mjabatanId,
		'mrekan1Id': mrekan1Id,
		'mrekanpicId': mrekanpicId,
		'picEmail': picEmail,
		'picHp': picHp,
		'picNama': picNama,
		'jabatanNama': jabatanNama,
		'peranan': peranan,
		'listCob': listCob,
		'alamat1': alamat1,
		'alamat2': alamat2,
		'statusPic': statusPic,
	};
}