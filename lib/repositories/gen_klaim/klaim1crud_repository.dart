import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_klaim/klaim1crud_api.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';

class Klaim1CrudRepository {

	Klaim1CrudAPI api = Klaim1CrudAPI();

	Future<ReturnDataAPI> klaim1CrudTambah(Klaim1CrudModel record) async {
		return await api.klaim1CrudTambahAPI(record);
	}
	Future<bool> klaim1CrudUbah(Klaim1CrudModel record) async {
		return await api.klaim1CrudUbahAPI(record);
	}
	Future<bool> klaim1CrudHapus(String klaim1Id) async {
		return await api.klaim1CrudHapusAPI(klaim1Id);
	}
	Future<Klaim1CrudModel> klaim1CrudLihat(String klaim1Id) async {
		return await api.klaim1CrudLihatAPI(klaim1Id);
	}
}
