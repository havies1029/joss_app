import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/calpar/calpar1crud_api.dart';
import 'package:joss_app/models/calpar/calpar1crud_model.dart';

class Calpar1CrudRepository {

	Calpar1CrudAPI api = Calpar1CrudAPI();

	Future<ReturnDataAPI> calpar1CrudTambah(Calpar1CrudModel record) async {
		return await api.calpar1CrudTambahAPI(record);
	}
	Future<bool> calpar1CrudUbah(Calpar1CrudModel record) async {
		return await api.calpar1CrudUbahAPI(record);
	}
	Future<bool> calpar1CrudHapus(String calpar1Id) async {
		return await api.calpar1CrudHapusAPI(calpar1Id);
	}
	Future<Calpar1CrudModel> calpar1CrudLihat(String calpar1Id) async {
		return await api.calpar1CrudLihatAPI(calpar1Id);
	}
}
