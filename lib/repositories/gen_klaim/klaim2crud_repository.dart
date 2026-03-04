import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_klaim/klaim2crud_api.dart';
import 'package:joss_app/models/gen_klaim/klaim2crud_model.dart';

class Klaim2CrudRepository {

	Klaim2CrudAPI api = Klaim2CrudAPI();

	Future<ReturnDataAPI> klaim2CrudTambah(Klaim2CrudModel record) async {
		return await api.klaim2CrudTambahAPI(record);
	}
	Future<bool> klaim2CrudUbah(Klaim2CrudModel record) async {
		return await api.klaim2CrudUbahAPI(record);
	}
	Future<bool> klaim2CrudHapus(String klaim2Id) async {
		return await api.klaim2CrudHapusAPI(klaim2Id);
	}
	Future<Klaim2CrudModel> klaim2CrudLihat(String klaim2Id) async {
		return await api.klaim2CrudLihatAPI(klaim2Id);
	}
}
