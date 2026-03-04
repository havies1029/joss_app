import 'package:joss_app/apis/klaimrinci/groupcobcari_api.dart';
import 'package:joss_app/models/klaimrinci/groupcobcari_model.dart';

class GroupcobCariRepository {

	Future<List<GroupcobCariModel>> getGroupcobCari(String statusId, String searchText) async {
		GroupcobCariAPI api = GroupcobCariAPI();
		return await api.getGroupcobCariAPI(statusId, searchText);
	}
}
