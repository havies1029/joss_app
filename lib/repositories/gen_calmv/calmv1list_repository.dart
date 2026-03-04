import 'package:joss_app/apis/gen_calmv/calmv1list_api.dart';
import 'package:joss_app/models/gen_calmv/calmv1list_model.dart';

import '../../models/responseAPI/returndataapi_model.dart';

class Calmv1ListRepository {

	Future<List<Calmv1ListModel>> getCalmv1List(String searchText, int hal) async {
		Calmv1ListAPI api = Calmv1ListAPI();
		return await api.getCalmv1ListAPI(searchText, hal);
	}

	Future<ReturnDataAPI> calmv2Regmv(String calmv1Id) async {
		Calmv1ListAPI api = Calmv1ListAPI();
		return await api.calmv2RegmvAPI(calmv1Id);
	}
}