import 'package:joss_app/apis/gen_profile/mrekangeneralidvlist_api.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvlist_model.dart';

class MRekanGeneralIdvListRepository {

	Future<List<MRekanGeneralIdvListModel>> getMRekanGeneralIdvList(String searchText, int hal) async {
		MRekanGeneralIdvListAPI api = MRekanGeneralIdvListAPI();
		return await api.getMRekanGeneralIdvListAPI(searchText, hal);
	}
}
