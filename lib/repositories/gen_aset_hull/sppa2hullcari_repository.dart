import 'package:joss_app/apis/gen_aset_hull/sppa2hullcari_api.dart';
import 'package:joss_app/models/gen_aset_hull/sppa2hullcari_model.dart';

class Sppa2hullCariRepository {

	Future<List<Sppa2hullCariModel>> getSppa2hullCari(String sppa1Id, String searchText, int hal) async {
		Sppa2hullCariAPI api = Sppa2hullCariAPI();
		return await api.getSppa2hullCariAPI(sppa1Id, searchText, hal);
	}
}
