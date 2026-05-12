import 'package:joss_app/apis/assetdetail/sppa2cari_api.dart';
import 'package:joss_app/models/assetdetail/sppa2cari_model.dart';

class Sppa2CariRepository {

	Future<List<Sppa2CariModel>> getSppa2Cari(String searchText, int hal) async {
		Sppa2CariAPI api = Sppa2CariAPI();
		return await api.getSppa2CariAPI(searchText, hal);
	}
}
