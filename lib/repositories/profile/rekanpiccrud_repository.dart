import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/profile/rekanpiccrud_api.dart';
import 'package:joss_app/models/profile/rekanpiccrud_model.dart';

class RekanPicCrudRepository {

	RekanPicCrudAPI api = RekanPicCrudAPI();

	Future<ReturnDataAPI> rekanPicCrudTambah(RekanPicCrudModel record) async {
		return await api.rekanPicCrudTambahAPI(record);
	}
	Future<bool> rekanPicCrudUbah(RekanPicCrudModel record) async {
		return await api.rekanPicCrudUbahAPI(record);
	}
	Future<bool> rekanPicCrudHapus(String mrekanpicId) async {
		return await api.rekanPicCrudHapusAPI(mrekanpicId);
	}
	Future<RekanPicCrudModel> rekanPicCrudLihat(String mrekanpicId) async {
		return await api.rekanPicCrudLihatAPI(mrekanpicId);
	}
}
