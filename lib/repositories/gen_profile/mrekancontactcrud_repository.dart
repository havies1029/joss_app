import 'package:joss_app/apis/gen_profile/mrekancontactcrud_api.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';

class MRekanContactCrudRepository {

	MRekanContactCrudAPI api = MRekanContactCrudAPI();
	
	Future<bool> mRekanContactCrudUbah(MRekanContactCrudModel record) async {
		return await api.mRekanContactCrudUbahAPI(record);
	}

	Future<MRekanContactCrudModel> mRekanContactCrudLihat() async {
		final result = await api.mRekanContactCrudLihatAPI();
		return result;
	}

}
