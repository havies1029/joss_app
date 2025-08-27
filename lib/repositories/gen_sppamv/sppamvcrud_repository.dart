import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_sppamv/sppamvcrud_api.dart';
import 'package:joss_app/models/gen_sppamv/sppamvcrud_model.dart';

class SppamvCrudRepository {

	SppamvCrudAPI api = SppamvCrudAPI();

	Future<ReturnDataAPI> sppamvCrudTambah(SppamvCrudModel record) async {
		return await api.sppamvCrudTambahAPI(record);
	}
	Future<bool> sppamvCrudUbah(SppamvCrudModel record) async {
		return await api.sppamvCrudUbahAPI(record);
	}
	Future<bool> sppamvCrudHapus(String sppa1Id) async {
		return await api.sppamvCrudHapusAPI(sppa1Id);
	}
	Future<SppamvCrudModel> sppamvCrudLihat(String sppa1Id) async {
		return await api.sppamvCrudLihatAPI(sppa1Id);
	}
}
