import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv1crud_api.dart';
import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';

class Regmv1CrudRepository {

	Regmv1CrudAPI api = Regmv1CrudAPI();

	Future<ReturnDataAPI> regmv1CrudTambah(Regmv1CrudModel record) async {
		return await api.regmv1CrudTambahAPI(record);
	}
	Future<bool> regmv1CrudUbah(Regmv1CrudModel record) async {
		return await api.regmv1CrudUbahAPI(record);
	}
	Future<bool> regmv1CrudHapus(String regmv1Id) async {
		return await api.regmv1CrudHapusAPI(regmv1Id);
	}
	Future<Regmv1CrudModel> regmv1CrudLihat(String regmv1Id) async {
		return await api.regmv1CrudLihatAPI(regmv1Id);
	}
}
