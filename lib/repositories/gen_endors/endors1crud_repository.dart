import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_endors/endors1crud_api.dart';
import 'package:joss_app/models/gen_endors/endors1crud_model.dart';

class Endors1CrudRepository {

	Endors1CrudAPI api = Endors1CrudAPI();

	Future<ReturnDataAPI> endors1CrudTambah(Endors1CrudModel record) async {
		return await api.endors1CrudTambahAPI(record);
	}
	Future<bool> endors1CrudUbah(Endors1CrudModel record) async {
		return await api.endors1CrudUbahAPI(record);
	}
	Future<bool> endors1CrudHapus(String endors1Id) async {
		return await api.endors1CrudHapusAPI(endors1Id);
	}
	Future<Endors1CrudModel> endors1CrudLihat(String endors1Id) async {
		return await api.endors1CrudLihatAPI(endors1Id);
	}
}
