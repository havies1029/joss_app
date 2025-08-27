import 'package:joss_app/apis/gen_sppapar/sppaparlist_api.dart';
import 'package:joss_app/models/gen_sppapar/sppaparlist_model.dart';

class SppaparListRepository {

	Future<List<SppaparListModel>> getSppaparList(String searchText, int hal) async {
		SppaparListAPI api = SppaparListAPI();
		return await api.getSppaparListAPI(searchText, hal);
	}
}
