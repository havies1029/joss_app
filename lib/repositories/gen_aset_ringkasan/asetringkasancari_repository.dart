import 'package:joss_app/apis/gen_aset_ringkasan/asetringkasancari_api.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';

class AsetRingkasanCariRepository {

	Future<List<AsetRingkasanCariModel>> getAsetRingkasanCari(String statusId, String searchText, int hal) async {
		AsetRingkasanCariAPI api = AsetRingkasanCariAPI();
		return await api.getAsetRingkasanCariAPI(statusId, searchText, hal);
	}
}
