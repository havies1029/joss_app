import 'package:joss_app/apis/gen_promo/promo1cari_api.dart';
import 'package:joss_app/models/gen_promo/promo1cari_model.dart';

class Promo1CariRepository {

	Future<List<Promo1CariModel>> getPromo1Cari(int hal) async {
		Promo1CariAPI api = Promo1CariAPI();
		return await api.getPromo1CariAPI(hal);
	}
}
