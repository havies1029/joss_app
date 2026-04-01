import 'package:flutter/cupertino.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar5form_api.dart';
import 'package:joss_app/models/regpar/regpar5form_model.dart';

class Regpar5FormRepository {

	Regpar5FormAPI api = Regpar5FormAPI();

	Future<ReturnDataAPI> regpar5FormTambah(Regpar5FormModel record) async {
		return await api.regpar5FormTambahAPI(record);
	}
	Future<bool> regpar5FormUbah(Regpar5FormModel record) async {
		return await api.regpar5FormUbahAPI(record);
	}
	Future<bool> regpar5FormHapus(String regpar5Id) async {
		return await api.regpar5FormHapusAPI(regpar5Id);
	}
	Future<Regpar5FormModel> regpar5FormLihat(String regpar1Id) async {
		return await api.regpar5FormLihatAPI(regpar1Id);
	}
	Future<Regpar5FormModel> regpar5FormHitungPremi(String regpar5Id) async {
		try {
			final result = await api.regpar5FormHitungPremiAPI(regpar5Id);
			return result;
		} catch (e) {
			rethrow; // biar error tetap naik ke caller
		}
	}

}
