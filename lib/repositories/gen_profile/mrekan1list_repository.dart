import 'package:joss_app/apis/gen_profile/mrekan1list_api.dart';
import 'package:joss_app/models/gen_profile/mrekan1list_model.dart';

class MRekan1ListRepository {

	Future<List<MRekan1ListModel>> getMRekan1List(String searchText, int hal) async {
		MRekan1ListAPI api = MRekan1ListAPI();
		return await api.getMRekan1ListAPI(searchText, hal);
	}
}
