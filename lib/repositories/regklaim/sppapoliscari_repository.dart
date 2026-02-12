import 'package:joss_app/apis/regklaim/sppapoliscari_api.dart';
import 'package:joss_app/models/regklaim/sppapoliscari_model.dart';

class SppapoliscariRepository {

	Future<List<SppapoliscariModel>> getSppapoliscari(String cobKlaimId, String searchText, int hal) async {
		SppapoliscariAPI api = SppapoliscariAPI();
		return await api.getSppapoliscariAPI(cobKlaimId, searchText, hal);
	}
}
