import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/profile/rekancontact_api.dart';
import 'package:joss_app/models/profile/rekancontact_model.dart';

class RekanContactRepository {

	RekanContactAPI api = RekanContactAPI();

	Future<ReturnDataAPI> rekanContactTambah(RekanContactModel record) async {
		return await api.rekanContactTambahAPI(record);
	}
	Future<bool> rekanContactUbah(RekanContactModel record) async {
		return await api.rekanContactUbahAPI(record);
	}
	Future<bool> rekanContactHapus(String mrekancontact1Id) async {
		return await api.rekanContactHapusAPI(mrekancontact1Id);
	}
	Future<RekanContactModel> rekanContactLihat(String mrekancontact1Id) async {
		return await api.rekanContactLihatAPI(mrekancontact1Id);
	}
}
