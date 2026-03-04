import 'package:joss_app/apis/gen_profile/mrekangeneralcmplist_api.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmplist_model.dart';

class MRekanGeneralCmpListRepository {

	Future<List<MRekanGeneralCmpListModel>> getMRekanGeneralCmpList(String searchText, int hal) async {
		MRekanGeneralCmpListAPI api = MRekanGeneralCmpListAPI();
		return await api.getMRekanGeneralCmpListAPI(searchText, hal);
	}
}
