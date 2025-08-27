import 'package:joss_app/apis/gen_promo/promo2cari_api.dart';
import 'package:joss_app/models/gen_promo/promo2cari_model.dart';

class Promo2CariRepository {

	Future<List<Promo2CariModel>> getPromo2Cari(String promo1Id, int hal) async {
		Promo2CariAPI api = Promo2CariAPI();
		return await api.getPromo2CariAPI(promo1Id, hal);
	}
}
