import 'package:joss_app/apis/gen_regmv/regmv1list_api.dart';
import 'package:joss_app/models/gen_regmv/regmv1list_model.dart';

class Regmv1ListRepository {

	Future<List<Regmv1ListModel>> getRegmv1List(String searchText, int hal) async {
		Regmv1ListAPI api = Regmv1ListAPI();
		return await api.getRegmv1ListAPI(searchText, hal);
	}
}
