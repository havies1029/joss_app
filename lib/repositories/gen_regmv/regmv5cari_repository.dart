import 'package:joss_app/apis/gen_regmv/regmv5cari_api.dart';
import 'package:joss_app/models/gen_regmv/regmv5cari_model.dart';

class Regmv5CariRepository {

	Future<List<Regmv5CariModel>> getRegmv5Cari(String regmv1Id) async {
		Regmv5CariAPI api = Regmv5CariAPI();
		return await api.getRegmv5CariAPI(regmv1Id);
	}
}
