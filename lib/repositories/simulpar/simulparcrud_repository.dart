import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/simulpar/simulparcrud_api.dart';
import 'package:joss_app/models/simulpar/calcpremipar_model.dart';
import 'package:joss_app/models/simulpar/simulparcrud_model.dart';

class SimulparCrudRepository {

	SimulparCrudAPI api = SimulparCrudAPI();

	Future<ReturnDataAPI> simulparCrudTambah(SimulparCrudModel record) async {
		return await api.simulparCrudTambahAPI(record);
	}
	Future<bool> simulparCrudUbah(SimulparCrudModel record) async {
		return await api.simulparCrudUbahAPI(record);
	}
	Future<bool> simulparCrudHapus(String simulpar1Id) async {
		return await api.simulparCrudHapusAPI(simulpar1Id);
	}
	Future<SimulparCrudModel> simulparCrudLihat(String simulpar1Id) async {
		return await api.simulparCrudLihatAPI(simulpar1Id);
	}

  Future<SimulparCrudModel> simulPARCrudInitValue() async {
		return await api.simulParCrudInitValueAPI();
	}

  Future<double> simulPARCrudGetRateFlexas(String okupasiId, String konstruksiId) async {
		return await api.simulParCrudGetRateFlexasAPI(okupasiId, konstruksiId);
	}

  Future<double> simulPARCrudGetRateTsfwd(String wilayahId) async {
		return await api.simulParCrudGetRateTsfwdAPI(wilayahId);
	}

  Future<double> simulPARCrudGetRateEqvet(String kabupatenId, String okupasiId) async {
		return await api.simulParCrudGetRateEqvetPI(kabupatenId, okupasiId);
	}  
  
  Future<CalcpremiparModel> simulPARCalPremi(SimulparCrudModel record) async {
		return await api.simulParCalPremiAPI(record);
	}
}
