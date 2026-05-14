import 'package:joss_app/apis/layanan/mlayanan1cari_api.dart';
import 'package:joss_app/models/layanan/mlayanan1cari_model.dart';

class Mlayanan1CariRepository {

	Future<List<Mlayanan1CariModel>> getMlayanan1Cari(String mlayanan1Id) async {
		Mlayanan1CariAPI api = Mlayanan1CariAPI();
		return await api.getMlayanan1CariAPI(mlayanan1Id);
	}
}
