import 'package:joss_app/models/combobox/combomjabatan_model.dart';

class MRekanPicCrudModel {
	bool? isDefault;
	String? mrekanpicId;
	String? picEmail;
	String? picHp;
	String? picNama;
	String? mjabatanId;
	ComboMJabatanModel? comboMJabatan;

	MRekanPicCrudModel({this.isDefault, this.mrekanpicId, 
		this.picEmail, this.picHp, 
		this.picNama, this.mjabatanId, this.comboMJabatan});

	factory MRekanPicCrudModel.fromJson(Map<String, dynamic> data) {
		ComboMJabatanModel? comboMJabatan;
		if (data['comboMJabatan'] != null) {
			comboMJabatan = ComboMJabatanModel.fromJson(data['comboMJabatan']);
		}

		return MRekanPicCrudModel(
			isDefault: data['isDefault']??false,
			mrekanpicId: data['mrekanpicId']??'',
			picEmail: data['picEmail']??'',
			picHp: data['picHp']??'',
			picNama: data['picNama']??'',
			mjabatanId: data['mjabatanId']??'',
			comboMJabatan: comboMJabatan
		);

	}

	Map<String, dynamic> toJson() =>
		{'isDefault': isDefault,
		'mrekanpicId': mrekanpicId,
		'picEmail': picEmail,
		'picHp': picHp,
		'picNama': picNama,
		'mjabatanId': mjabatanId,
		'comboMJabatan': comboMJabatan?.toJson()};

}
