import 'package:joss_app/apis/simulpar/simulparlist_api.dart';
import 'package:joss_app/models/simulpar/simulparlist_model.dart';

class SimulparListRepository {

	Future<List<SimulparListModel>> getSimulparList(String searchText, int hal) async {
		SimulparListAPI api = SimulparListAPI();
		return await api.getSimulparListAPI(searchText, hal);
	}
}
