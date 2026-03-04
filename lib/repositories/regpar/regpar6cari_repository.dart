import 'package:joss_app/apis/regpar/regpar6cari_api.dart';
import 'package:joss_app/models/regpar/regpar6cari_model.dart';

class Regpar6CariRepository {

	Future<List<Regpar6CariModel>> getRegpar6Cari(String regpar1Id) async {
		Regpar6CariAPI api = Regpar6CariAPI();
		return await api.getRegpar6CariAPI(regpar1Id);
	}
}
