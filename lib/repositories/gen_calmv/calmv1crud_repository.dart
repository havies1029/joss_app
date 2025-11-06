import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_calmv/calmv1crud_api.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';

class Calmv1CrudRepository {

	Calmv1CrudAPI api = Calmv1CrudAPI();

	Future<ReturnDataAPI> calmv1CrudTambah(Calmv1CrudModel record) async {
		return await api.calmv1CrudTambahAPI(record);
	}
	Future<bool> calmv1CrudUbah(Calmv1CrudModel record) async {
		return await api.calmv1CrudUbahAPI(record);
	}
	Future<bool> calmv1CrudHapus(String calmv1Id) async {
		return await api.calmv1CrudHapusAPI(calmv1Id);
	}
	Future<Calmv1CrudModel> calmv1CrudLihat(String calmv1Id) async {
		return await api.calmv1CrudLihatAPI(calmv1Id);
	}
}
