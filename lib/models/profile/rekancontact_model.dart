import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';

class RekanContactModel {
	String alamat1;
	String email;
	String mrekan1Id;
	String mrekancontact1Id;
	String telp;
	String? mkotaId;
	ComboMKotaModel? comboMKota;
	String? mpropinsiId;
	ComboMPropinsiModel? comboMPropinsi;
	String? rkodeposId;
	ComboRKodeposModel? comboRKodepos;

	RekanContactModel({required this.alamat1, required this.email, 
		required this.mrekan1Id, required this.mrekancontact1Id, 
		required this.telp, this.mkotaId, this.comboMKota, 
		this.mpropinsiId, this.comboMPropinsi, this.rkodeposId, this.comboRKodepos});

	factory RekanContactModel.fromJson(Map<String, dynamic> data) {
		ComboMKotaModel? comboMKota;
		if (data['comboMKota'] != null) {
			comboMKota = ComboMKotaModel.fromJson(data['comboMKota']);
		}

		ComboMPropinsiModel? comboMPropinsi;
		if (data['comboMPropinsi'] != null) {
			comboMPropinsi = ComboMPropinsiModel.fromJson(data['comboMPropinsi']);
		}

		ComboRKodeposModel? comboRKodepos;
		if (data['comboRKodepos'] != null) {
			comboRKodepos = ComboRKodeposModel.fromJson(data['comboRKodepos']);
		}

		return RekanContactModel(
			alamat1: data['alamat1']??'',
			email: data['email']??'',
			mrekan1Id: data['mrekan1Id']??'',
			mrekancontact1Id: data['mrekancontact1Id']??'',
			telp: data['telp']??'',
			mkotaId: data['mkotaId']??'',
			comboMKota: comboMKota,
			mpropinsiId: data['mpropinsiId']??'',
			comboMPropinsi: comboMPropinsi,
			rkodeposId: data['rkodeposId']??'',
			comboRKodepos: comboRKodepos
		);

	}

	Map<String, dynamic> toJson() =>
		{'alamat1': alamat1,
		'email': email,
		'mrekan1Id': mrekan1Id,
		'mrekancontact1Id': mrekancontact1Id,
		'telp': telp,
		'mkotaId': mkotaId,
		'comboMKota': comboMKota?.toJson(),
		'mpropinsiId': mpropinsiId,
		'comboMPropinsi': comboMPropinsi?.toJson(),
		'rkodeposId': rkodeposId,
		'comboRKodepos': comboRKodepos?.toJson()};

}
