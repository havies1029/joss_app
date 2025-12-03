import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar1crud_api.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';

class Regpar1CrudRepository {

	Regpar1CrudAPI api = Regpar1CrudAPI();

	Future<ReturnDataAPI> regpar1CrudTambah(Regpar1CrudModel record) async {
		return await api.regpar1CrudTambahAPI(record);
	}
	Future<bool> regpar1CrudUbah(Regpar1CrudModel record) async {
		return await api.regpar1CrudUbahAPI(record);
	}
	Future<bool> regpar1CrudHapus(String regpar1Id) async {
		return await api.regpar1CrudHapusAPI(regpar1Id);
	}
	Future<Regpar1CrudModel> regpar1CrudLihat(String regpar1Id) async {
		return await api.regpar1CrudLihatAPI(regpar1Id);
	}
}
