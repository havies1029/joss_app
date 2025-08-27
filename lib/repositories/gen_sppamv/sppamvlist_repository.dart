import 'package:joss_app/apis/gen_sppamv/sppamvlist_api.dart';
import 'package:joss_app/models/gen_sppamv/sppamvlist_model.dart';

class SppamvListRepository {

	Future<List<SppamvListModel>> getSppamvList(String searchText, int hal) async {
		SppamvListAPI api = SppamvListAPI();
		return await api.getSppamvListAPI(searchText, hal);
	}
}
