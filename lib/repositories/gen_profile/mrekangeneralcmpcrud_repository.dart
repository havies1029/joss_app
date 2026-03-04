import 'package:joss_app/apis/gen_profile/mrekangeneralcmpcrud_api.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmpcrud_model.dart';

class MRekanGeneralCmpCrudRepository {

	MRekanGeneralCmpCrudAPI api = MRekanGeneralCmpCrudAPI();

	Future<bool> mRekanGeneralCmpCrudUbah(MRekanGeneralCmpCrudModel record) async {
		return await api.mRekanGeneralCmpCrudUbahAPI(record);
	}

	Future<MRekanGeneralCmpCrudModel> mRekanGeneralCmpCrudLihat() async {
		return await api.mRekanGeneralCmpCrudLihatAPI();
	}
}
