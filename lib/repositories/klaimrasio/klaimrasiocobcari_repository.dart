import 'package:joss_app/apis/klaimrasio/klaimrasiocobcari_api.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiocari_model.dart';

class KlaimrasiocobCariRepository {

	Future<KlaimrasiocariModel> getKlaimrasiocobCari(String searchText) async {
		KlaimrasiocobCariAPI api = KlaimrasiocobCariAPI();
		return await api.getKlaimrasiocobCariAPI(searchText);
	}
}
