import 'dart:typed_data';

import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv4form_api.dart';

import '../../models/gen_regmv/regmv4form_model.dart';

class Regmv4FormRepository {

	Regmv4FormAPI api = Regmv4FormAPI();

	Future<ReturnDataAPI> regmv4FormTambah(Regmv4FormModel record) async {
		return await api.regmv4FormTambahAPI(record);
	}
	Future<bool> regmv4FormUbah(Regmv4FormModel record) async {
		return await api.regmv4FormUbahAPI(record);
	}
	Future<bool> regmv4FormHapus(String regmv4Id) async {
		return await api.regmv4FormHapusAPI(regmv4Id);
	}
	Future<Regmv4FormModel> regmv4FormLihat(String regmv4Id) async {
		return await api.regmv4FormLihatAPI(regmv4Id);
	}
}
