import 'package:joss_app/apis/regother/regother3cari_api.dart';
import 'package:joss_app/models/regother/regother3cari_model.dart';

class Regother3cariRepository {

	Future<List<Regother3cariModel>> getRegother3cari(String regother1Id) async {
		Regother3cariAPI api = Regother3cariAPI();
		return await api.getRegother3cariAPI(regother1Id);
	}
}
