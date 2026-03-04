import 'package:joss_app/apis/gen_regmv/regmv4cari_api.dart';
import 'package:joss_app/models/gen_regmv/regmv4cari_model.dart';

class Regmv4CariRepository {

	Future<List<Regmv4CariModel>> getRegmv4Cari(String regmv1Id) async {
		Regmv4CariAPI api = Regmv4CariAPI();
		return await api.getRegmv4CariAPI(regmv1Id);
	}
}
