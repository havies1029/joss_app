import 'package:joss_app/apis/gen_profile/mrekancontactlist_api.dart';
import 'package:joss_app/models/gen_profile/mrekancontactlist_model.dart';

class MRekanContactListRepository {

	Future<List<MRekanContactListModel>> getMRekanContactList(String searchText, int hal) async {
		MRekanContactListAPI api = MRekanContactListAPI();
		return await api.getMRekanContactListAPI(searchText, hal);
	}
}
