import 'package:joss_app/apis/regother/regother1list_api.dart';
import 'package:joss_app/models/regother/regother1list_model.dart';

class Regother1ListRepository {

	Future<List<Regother1ListModel>> getRegother1List(String searchText, int hal) async {
		Regother1ListAPI api = Regother1ListAPI();
		return await api.getRegother1ListAPI(searchText, hal);
	}
}
