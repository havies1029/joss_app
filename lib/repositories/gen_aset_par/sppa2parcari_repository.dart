import 'package:joss_app/apis/gen_aset_par/sppa2parcari_api.dart';
import 'package:joss_app/models/gen_aset_par/sppa2parcari_model.dart';

class Sppa2parCariRepository {

	Future<List<Sppa2parCariModel>> getSppa2parCari(String sppa1Id, String searchText, int hal) async {
		Sppa2parCariAPI api = Sppa2parCariAPI();
		return await api.getSppa2parCariAPI(sppa1Id, searchText, hal);
	}
}
