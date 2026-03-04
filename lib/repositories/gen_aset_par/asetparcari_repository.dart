import 'package:joss_app/apis/gen_aset_par/asetparcari_api.dart';
import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';

class AsetParCariRepository {

	Future<List<AsetParCariModel>> getAsetParCari(String statusId, String searchText, int hal) async {
		AsetParCariAPI api = AsetParCariAPI();
		return await api.getAsetParCariAPI(statusId, searchText, hal);
	}
}
