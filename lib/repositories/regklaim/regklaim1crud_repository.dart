import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regklaim/regklaim1crud_api.dart';
import 'package:joss_app/models/regklaim/regklaim1crud_model.dart';

class Regklaim1CrudRepository {

	Regklaim1CrudAPI api = Regklaim1CrudAPI();

	Future<ReturnDataAPI> regklaim1CrudTambah(Regklaim1CrudModel record) async {
		return await api.regklaim1CrudTambahAPI(record);
	}

  Future<ReturnDataAPI> regklaim1Tambah4PolisJps(String sppa1Id) async {
    return await api.regklaim1Tambah4PolisJpsAPI(sppa1Id);
  }

  Future<ReturnDataAPI> regklaimToKlaim(String regklaim1Id) async {
    return await api.regklaimToKlaimAPI(regklaim1Id);
  }

	Future<bool> regklaim1CrudUbah(Regklaim1CrudModel record) async {
		return await api.regklaim1CrudUbahAPI(record);
	}
	Future<bool> regklaim1CrudHapus(String regklaim1Id) async {
		return await api.regklaim1CrudHapusAPI(regklaim1Id);
	}
	Future<Regklaim1CrudModel> regklaim1CrudLihat(String regklaim1Id) async {
		return await api.regklaim1CrudLihatAPI(regklaim1Id);
	}
}
