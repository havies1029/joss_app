import 'package:joss_app/apis/regpar/regpar1list_api.dart';
import 'package:joss_app/models/regpar/regpar1list_model.dart';

class Regpar1ListRepository {

	Future<List<Regpar1ListModel>> getRegpar1List(String searchText, int hal) async {
		Regpar1ListAPI api = Regpar1ListAPI();
		return await api.getRegpar1ListAPI(searchText, hal);
	}
}
