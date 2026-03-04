import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_sppapar/sppaparcrud_api.dart';
import 'package:joss_app/models/gen_sppapar/sppaparcrud_model.dart';

class SppaparCrudRepository {

	SppaparCrudAPI api = SppaparCrudAPI();

	Future<ReturnDataAPI> sppaparCrudTambah(SppaparCrudModel record) async {
		return await api.sppaparCrudTambahAPI(record);
	}
	Future<bool> sppaparCrudUbah(SppaparCrudModel record) async {
		return await api.sppaparCrudUbahAPI(record);
	}
	Future<bool> sppaparCrudHapus(String sppa1Id) async {
		return await api.sppaparCrudHapusAPI(sppa1Id);
	}
	Future<SppaparCrudModel> sppaparCrudLihat(String sppa1Id) async {
		return await api.sppaparCrudLihatAPI(sppa1Id);
	}
}
