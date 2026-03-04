import 'package:joss_app/apis/gen_aset_dashboard/asetdashboardcari_api.dart';
import 'package:joss_app/models/gen_aset_dashboard/asetdashboardcari_model.dart';

class AsetDashboardCariRepository {

	Future<List<AsetDashboardCariModel>> getAsetDashboardCari(String cobAppId) async {
		AsetDashboardCariAPI api = AsetDashboardCariAPI();
		return await api.getAsetDashboardCariAPI(cobAppId);
	}
}
