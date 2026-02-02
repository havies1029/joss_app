import 'package:joss_app/apis/payment/historybayar2cari_api.dart';
import 'package:joss_app/models/payment/historybayar2cari_model.dart';

class Historybayar2CariRepository {

	Future<List<Historybayar2CariModel>> getHistorybayar2Cari(String inv1Id) async {
		Historybayar2CariAPI api = Historybayar2CariAPI();
		return await api.getHistorybayar2CariAPI(inv1Id);
	}
}
