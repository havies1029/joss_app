//generate from : usp_flutter_crud_repository

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/perbaruiklaimmv/klaimmvstatuscrud_api.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscrud_model.dart';

class KlaimmvstatuscrudRepository {

	KlaimmvstatuscrudAPI api = KlaimmvstatuscrudAPI();

	Future<ReturnDataAPI> klaimmvstatuscrudTambah(KlaimmvstatuscrudModel record) async {
		return await api.klaimmvstatuscrudTambahAPI(record);
	}
	Future<bool> klaimmvstatuscrudUbah(KlaimmvstatuscrudModel record) async {
		return await api.klaimmvstatuscrudUbahAPI(record);
	}
	Future<bool> klaimmvstatuscrudHapus(String klaim1Id) async {
		return await api.klaimmvstatuscrudHapusAPI(klaim1Id);
	}
	Future<KlaimmvstatuscrudModel?> klaimmvstatuscrudLihat(String klaim1Id) async {
		return await api.klaimmvstatuscrudLihatAPI(klaim1Id);
	}
}
