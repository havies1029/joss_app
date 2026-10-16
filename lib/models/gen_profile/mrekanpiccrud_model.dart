import '../combobox/combomjabatan_model.dart';

class MRekanPicCrudModel {
	bool? isDefault;
	String? mrekanpicId;
	String? picEmail;
	String? picHp;
	String? picNama;
	String? emailReqtokenId;
	String? hpReqtokenId;
	String? emailChangeRequestId;
	String? hpChangeRequestId;

	String? jabatanDesc;
	String? mjabatanId;
	String? alamat1;
	String? alamat2;

	ComboMJabatanModel? comboMJabatan;

	MRekanPicCrudModel({
		this.isDefault,
		this.mrekanpicId,
		this.picEmail,
		this.picHp,
		this.picNama,
		this.emailReqtokenId,
		this.hpReqtokenId,
		this.emailChangeRequestId,
		this.hpChangeRequestId,
		this.jabatanDesc,
		this.mjabatanId,
		this.alamat1,
		this.alamat2,
		this.comboMJabatan
	});

	factory MRekanPicCrudModel.fromJson(Map<String, dynamic> data) {
		ComboMJabatanModel? comboMJabatan;
		if (data['comboMJabatan'] != null) {
			comboMJabatan = ComboMJabatanModel.fromJson(data['comboMJabatan']);
		}

		return MRekanPicCrudModel(
			isDefault: data['isDefault'] ?? false,
			mrekanpicId: data['mrekanpicId'] ?? '',
			picEmail: data['picEmail'] ?? '',
			picHp: data['picHp'] ?? '',
			picNama: data['picNama'] ?? '',
			emailReqtokenId: data['emailReqtokenId'] ?? '',
			hpReqtokenId: data['hpReqtokenId'] ?? '',
			emailChangeRequestId: data['emailChangeRequestId'] ?? '',
			hpChangeRequestId: data['hpChangeRequestId'] ?? '',
			jabatanDesc: data['jabatanDesc'] ?? '',
			mjabatanId: data['mjabatanId']??'',
			alamat1: data['alamat1'] ?? '',
			alamat2: data['alamat2'], // optional
			comboMJabatan: comboMJabatan
		);
	}

	Map<String, dynamic> toJson() => {
		'isDefault': isDefault,
		'mrekanpicId': mrekanpicId,
		'picEmail': picEmail,
		'picHp': picHp,
		'picNama': picNama,
		'emailReqtokenId': emailReqtokenId,
		'hpReqtokenId': hpReqtokenId,
		'emailChangeRequestId': emailChangeRequestId,
		'hpChangeRequestId': hpChangeRequestId,
		'jabatanDesc': jabatanDesc,
		'mjabatanId': mjabatanId,
		'alamat1': alamat1,
		'alamat2': alamat2,
		'comboMJabatan': comboMJabatan?.toJson()
	};
}
