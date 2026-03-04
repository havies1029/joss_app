import 'package:joss_app/apis/gen_klaim/klaim2list_api.dart';
import 'package:joss_app/models/gen_klaim/klaim2list_model.dart';

class Klaim2ListRepository {

	Future<List<Klaim2ListModel>> getKlaim2List(String searchText, int hal) async {
		Klaim2ListAPI api = Klaim2ListAPI();
		return await api.getKlaim2ListAPI(searchText, hal);
	}
}
