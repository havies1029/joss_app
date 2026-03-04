import 'package:joss_app/apis/regendors/regendors2cari_api.dart';
import 'package:joss_app/models/regendors/regendors2cari_model.dart';

class Regendors2CariRepository {

	Future<List<Regendors2CariModel>> getRegendors2Cari(String regendors1Id) async {
		Regendors2CariAPI api = Regendors2CariAPI();
		return await api.getRegendors2CariAPI(regendors1Id);
	}
}
