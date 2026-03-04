import 'package:joss_app/apis/klaim/klaim1list_api.dart';
import 'package:joss_app/models/klaim/klaim1list_model.dart';

class Klaim1ListRepository {

	Future<List<Klaim1ListModel>> getKlaim1List(String searchText, int hal) async {
		Klaim1ListAPI api = Klaim1ListAPI();
		return await api.getKlaim1ListAPI(searchText, hal);
	}
}
