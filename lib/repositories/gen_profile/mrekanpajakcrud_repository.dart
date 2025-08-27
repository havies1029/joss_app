// import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_profile/mrekanpajakcrud_api.dart';
import 'package:joss_app/models/gen_profile/mrekanpajakcrud_model.dart';

class MRekanPajakCrudRepository {

	MRekanPajakCrudAPI api = MRekanPajakCrudAPI();

	Future<bool> mRekanPajakCrudUbah(MRekanPajakCrudModel record) async {
		return await api.mRekanPajakCrudUbahAPI(record);
	}

	Future<MRekanPajakCrudModel> mRekanPajakCrudLihat() async {
		return await api.mRekanPajakCrudLihatAPI();
	}
}
