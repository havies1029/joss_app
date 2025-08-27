import 'package:joss_app/apis/gen_profile/mrekanbanklist_api.dart';
import 'package:joss_app/models/gen_profile/mrekanbanklist_model.dart';

class MRekanBankListRepository {

	Future<List<MRekanBankListModel>> getMRekanBankList(String searchText, int hal) async {
		MRekanBankListAPI api = MRekanBankListAPI();
		return await api.getMRekanBankListAPI(searchText, hal);
	}
}
