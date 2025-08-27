import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/profile/mrekangeneral_api.dart';
import 'package:joss_app/models/profile/mrekangeneral_model.dart';

class MRekanGeneralRepository {

	MRekanGeneralAPI api = MRekanGeneralAPI();

	Future<ReturnDataAPI> mRekanGeneralTambah(MRekanGeneralModel record) async {
		return await api.mRekanGeneralTambahAPI(record);
	}
	Future<bool> mRekanGeneralUbah(MRekanGeneralModel record) async {
		return await api.mRekanGeneralUbahAPI(record);
	}
	Future<bool> mRekanGeneralHapus(String mrekan1Id) async {
		return await api.mRekanGeneralHapusAPI(mrekan1Id);
	}
	Future<MRekanGeneralModel> mRekanGeneralLihat(String mrekan1Id) async {
		return await api.mRekanGeneralLihatAPI(mrekan1Id);
	}
}
