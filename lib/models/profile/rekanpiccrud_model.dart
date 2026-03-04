
class RekanPicCrudModel {
	int isDefault;
	String mrekanpicId;
	String picEmail;
	String picHp;
	String picNama;

	RekanPicCrudModel({required this.isDefault, required this.mrekanpicId, 
		required this.picEmail, required this.picHp, 
		required this.picNama});

	factory RekanPicCrudModel.fromJson(Map<String, dynamic> data) {
		return RekanPicCrudModel(
			isDefault: int.tryParse(data['isDefault'].toString())??0,
			mrekanpicId: data['mrekanpicId']??'',
			picEmail: data['picEmail']??'',
			picHp: data['picHp']??'',
			picNama: data['picNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'isDefault': isDefault.toString(),
		'mrekanpicId': mrekanpicId,
		'picEmail': picEmail,
		'picHp': picHp,
		'picNama': picNama};

}
