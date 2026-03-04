import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';

class MRekanPajakCrudModel {
	String alamat1;
	String mrekanpajakId;
	String npwpNo;
	String? mkotaId;
	ComboMKotaModel? comboMKota;
	String? mpropinsiId;
	ComboMPropinsiModel? comboMPropinsi;
	String? rkodeposId;
	ComboRKodeposModel? comboRKodepos;

	MRekanPajakCrudModel({required this.alamat1, required this.mrekanpajakId, 
		required this.npwpNo, this.mkotaId, this.comboMKota, 
		this.mpropinsiId, this.comboMPropinsi, this.rkodeposId, this.comboRKodepos});

	factory MRekanPajakCrudModel.fromJson(Map<String, dynamic> data) {
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

		return MRekanPajakCrudModel(
			alamat1: data['alamat1']??'',
			mrekanpajakId: data['mrekanpajakId']??'',
			npwpNo: data['npwpNo']??'',
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
		'mrekanpajakId': mrekanpajakId,
		'npwpNo': npwpNo,
		'mkotaId': mkotaId,
		'comboMKota': comboMKota?.toJson(),
		'mpropinsiId': mpropinsiId,
		'comboMPropinsi': comboMPropinsi?.toJson(),
		'rkodeposId': rkodeposId,
		'comboRKodepos': comboRKodepos?.toJson()};

}
