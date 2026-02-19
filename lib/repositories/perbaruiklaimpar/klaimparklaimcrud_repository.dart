//generate from : usp_flutter_crud_repository

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/perbaruiklaimpar/klaimparklaimcrud_api.dart';
import 'package:joss_app/models/perbaruiklaimpar/klaimparklaimcrud_model.dart';

class KlaimparklaimcrudRepository {

	KlaimparklaimcrudAPI api = KlaimparklaimcrudAPI();

	Future<ReturnDataAPI> klaimparklaimcrudTambah(KlaimparklaimcrudModel record) async {
		return await api.klaimparklaimcrudTambahAPI(record);
	}
	Future<bool> klaimparklaimcrudUbah(KlaimparklaimcrudModel record) async {
		return await api.klaimparklaimcrudUbahAPI(record);
	}
	Future<bool> klaimparklaimcrudHapus(String klaim1Id) async {
		return await api.klaimparklaimcrudHapusAPI(klaim1Id);
	}
	Future<KlaimparklaimcrudModel?> klaimparklaimcrudLihat(String klaim1Id) async {
		return await api.klaimparklaimcrudLihatAPI(klaim1Id);
	}
}
