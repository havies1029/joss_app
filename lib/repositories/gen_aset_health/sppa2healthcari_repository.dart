import 'package:joss_app/apis/gen_aset_health/sppa2healthcari_api.dart';
import 'package:joss_app/models/gen_aset_health/sppa2healthcari_model.dart';

class Sppa2healthCariRepository {

	Future<List<Sppa2healthCariModel>> getSppa2healthCari(String sppa1Id, String searchText, int hal) async {
		Sppa2healthCariAPI api = Sppa2healthCariAPI();
		return await api.getSppa2healthCariAPI(sppa1Id, searchText, hal);
	}
}
