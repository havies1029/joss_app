import 'package:joss_app/apis/payment/pay2cari_api.dart';
import 'package:joss_app/models/payment/pay2cari_model.dart';

class Pay2CariRepository {

	Future<List<Pay2CariModel>> getPay2Cari(String ar1Id) async {
		Pay2CariAPI api = Pay2CariAPI();
		return await api.getPay2CariAPI(ar1Id);
	}
}
