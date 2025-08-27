import 'package:joss_app/apis/gen_aset_mv/asetmvcari_api.dart';
import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';

class AsetMvCariRepository {

	Future<List<AsetMvCariModel>> getAsetMvCari(String statusId, String searchText, int hal) async {
		AsetMvCariAPI api = AsetMvCariAPI();
		return await api.getAsetMvCariAPI(statusId, searchText, hal);
	}
}
