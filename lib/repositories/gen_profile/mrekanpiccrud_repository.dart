import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_profile/mrekanpiccrud_api.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';

class MRekanPicCrudRepository {

	MRekanPicCrudAPI api = MRekanPicCrudAPI();

	Future<ReturnDataAPI> mRekanPicCrudTambah(MRekanPicCrudModel record) async {
		return await api.mRekanPicCrudTambahAPI(record);
	}
	Future<bool> mRekanPicCrudUbah(MRekanPicCrudModel record) async {
		return await api.mRekanPicCrudUbahAPI(record);
	}
	Future<bool> mRekanPicCrudHapus(String mrekanpicId) async {
		return await api.mRekanPicCrudHapusAPI(mrekanpicId);
	}
	Future<MRekanPicCrudModel> mRekanPicCrudLihat(String mrekanpicId) async {
		return await api.mRekanPicCrudLihatAPI(mrekanpicId);
	}
}
