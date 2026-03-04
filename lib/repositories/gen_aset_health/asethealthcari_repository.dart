import 'package:joss_app/apis/gen_aset_health/asethealthcari_api.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

class AsetHealthCariRepository {

	Future<List<AsetHealthCariModel>> getAsetHealthCari(String statusId, String searchText, int hal) async {
		AsetHealthCariAPI api = AsetHealthCariAPI();
		return await api.getAsetHealthCariAPI(statusId, searchText, hal);
	}
}
