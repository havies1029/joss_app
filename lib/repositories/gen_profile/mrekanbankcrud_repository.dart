import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_profile/mrekanbankcrud_api.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';

class MRekanBankCrudRepository {

	MRekanBankCrudAPI api = MRekanBankCrudAPI();

	Future<ReturnDataAPI> mRekanBankCrudTambah(MRekanBankCrudModel record) async {
		return await api.mRekanBankCrudTambahAPI(record);
	}
	Future<bool> mRekanBankCrudUbah(MRekanBankCrudModel record) async {
		return await api.mRekanBankCrudUbahAPI(record);
	}
	Future<bool> mRekanBankCrudHapus(String mrekanbankId) async {
		return await api.mRekanBankCrudHapusAPI(mrekanbankId);
	}
	Future<MRekanBankCrudModel> mRekanBankCrudLihat(String mrekanbankId) async {
		final result = await api.mRekanBankCrudLihatAPI(mrekanbankId);

		return result;
	}

}
