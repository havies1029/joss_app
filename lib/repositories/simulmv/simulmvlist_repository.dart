import 'package:joss_app/apis/simulmv/simulmvlist_api.dart';
import 'package:joss_app/models/simulmv/simulmvlist_model.dart';

class SimulmvListRepository {

	Future<List<SimulmvListModel>> getSimulmvList(String searchText, int hal) async {
		SimulmvListAPI api = SimulmvListAPI();
		return await api.getSimulmvListAPI(searchText, hal);
	}
}
