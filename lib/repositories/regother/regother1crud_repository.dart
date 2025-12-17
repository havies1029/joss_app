import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regother/regother1crud_api.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';

class Regother1CrudRepository {

	Regother1CrudAPI api = Regother1CrudAPI();

	Future<ReturnDataAPI> regother1CrudTambah(Regother1CrudModel record) async {
		return await api.regother1CrudTambahAPI(record);
	}
	Future<bool> regother1CrudUbah(Regother1CrudModel record) async {
		return await api.regother1CrudUbahAPI(record);
	}
	Future<bool> regother1CrudHapus(String regother1Id) async {
		return await api.regother1CrudHapusAPI(regother1Id);
	}
	Future<Regother1CrudModel> regother1CrudLihat(String regother1Id) async {
		return await api.regother1CrudLihatAPI(regother1Id);
	}
}
