import 'package:joss_app/apis/gen_aset_mv/sppa2mvcari_api.dart';
import 'package:joss_app/models/gen_aset_mv/sppa2mvcari_model.dart';

class Sppa2mvCariRepository {

	Future<List<Sppa2mvCariModel>> getSppa2mvCari(String sppa1Id, String searchText, int hal) async {
		Sppa2mvCariAPI api = Sppa2mvCariAPI();
		return await api.getSppa2mvCariAPI(sppa1Id, searchText, hal);
	}
}
