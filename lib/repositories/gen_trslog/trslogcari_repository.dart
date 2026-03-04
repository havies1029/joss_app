import 'package:joss_app/apis/gen_trslog/trslogcari_api.dart';
import 'package:joss_app/models/gen_trslog/trslogcari_model.dart';

class TrslogCariRepository {

	Future<List<TrslogCariModel>> getTrslogCari(String searchText, int hal) async {
		TrslogCariAPI api = TrslogCariAPI();
		return await api.getTrslogCariAPI(searchText, hal);
	}
}
