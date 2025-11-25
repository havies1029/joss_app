import 'package:joss_app/apis/calpar/calpar1list_api.dart';
import 'package:joss_app/models/calpar/calpar1list_model.dart';

class Calpar1ListRepository {

	Future<List<Calpar1ListModel>> getCalpar1List(String searchText, int hal) async {
		Calpar1ListAPI api = Calpar1ListAPI();
		return await api.getCalpar1ListAPI(searchText, hal);
	}
}
