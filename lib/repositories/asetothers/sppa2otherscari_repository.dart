import 'package:joss_app/apis/asetothers/sppa2otherscari_api.dart';
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';

class Sppa2othersCariRepository {

	Future<List<Sppa2othersCariModel>> getSppa2othersCari(String sppa1Id, String searchText, int hal) async {
		Sppa2othersCariAPI api = Sppa2othersCariAPI();
		return await api.getSppa2othersCariAPI(sppa1Id, searchText, hal);
	}
}
