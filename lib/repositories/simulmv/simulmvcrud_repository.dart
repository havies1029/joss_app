import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/simulmv/simulmvcrud_api.dart';
import 'package:joss_app/models/simulmv/simulmvcrud_model.dart';

class SimulmvCrudRepository {

	SimulmvCrudAPI api = SimulmvCrudAPI();

	Future<ReturnDataAPI> simulmvCrudTambah(SimulmvCrudModel record) async {
		return await api.simulmvCrudTambahAPI(record);
	}
	Future<bool> simulmvCrudUbah(SimulmvCrudModel record) async {
		return await api.simulmvCrudUbahAPI(record);
	}
	Future<bool> simulmvCrudHapus(String simulmv1Id) async {
		return await api.simulmvCrudHapusAPI(simulmv1Id);
	}
	Future<SimulmvCrudModel> simulmvCrudLihat(String simulmv1Id) async {
		return await api.simulmvCrudLihatAPI(simulmv1Id);
	}
  Future<SimulmvCrudModel> simulMVCrudInitValue() async {
		return await api.simulMVCrudInitValueAPI();
	}
}
