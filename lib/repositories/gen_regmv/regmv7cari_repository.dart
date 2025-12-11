import 'package:joss_app/apis/gen_regmv/regmv7cari_api.dart';
import 'package:joss_app/models/gen_regmv/regmv7cari_model.dart';

class Regmv7CariRepository {

	Future<List<Regmv7CariModel>> getRegmv7Cari(String regmv1Id) async {
		Regmv7CariAPI api = Regmv7CariAPI();
		return await api.getRegmv7CariAPI(regmv1Id);
	}
}
