import 'package:joss_app/apis/gen_profile/mrekanpajaklist_api.dart';
import 'package:joss_app/models/gen_profile/mrekanpajaklist_model.dart';

class MRekanPajakListRepository {

	Future<List<MRekanPajakListModel>> getMRekanPajakList(String searchText, int hal) async {
		MRekanPajakListAPI api = MRekanPajakListAPI();
		return await api.getMRekanPajakListAPI(searchText, hal);
	}
}
