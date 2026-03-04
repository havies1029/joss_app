import 'package:joss_app/apis/combobox/combomvtipelist_api.dart';
import 'package:joss_app/models/combobox/combomvtipelist_model.dart';

class ComboMvtipeListRepository {

	Future<List<ComboMvtipeListModel>> getComboMvtipeList(String filter) async {
		ComboMvtipeListAPI api = ComboMvtipeListAPI();
		return await api.getComboMvtipeListAPI(filter);
	}
}
