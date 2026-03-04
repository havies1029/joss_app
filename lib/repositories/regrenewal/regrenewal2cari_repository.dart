import 'package:joss_app/apis/regrenewal/regrenewal2cari_api.dart';
import 'package:joss_app/models/regrenewal/regrenewal2cari_model.dart';

class Regrenewal2CariRepository {

	Future<List<Regrenewal2CariModel>> getRegrenewal2Cari(String regrenewal1Id) async {
		Regrenewal2CariAPI api = Regrenewal2CariAPI();
		return await api.getRegrenewal2CariAPI(regrenewal1Id);
	}
}
