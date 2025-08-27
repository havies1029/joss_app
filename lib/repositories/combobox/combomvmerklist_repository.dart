import 'package:joss_app/apis/combobox/combomvmerklist_api.dart';
import 'package:joss_app/models/combobox/combomvmerklist_model.dart';

class ComboMvmerkListRepository {

	Future<List<ComboMvmerkListModel>> getComboMvmerkList(String filter) async {
		ComboMvmerkListAPI api = ComboMvmerkListAPI();
		return await api.getComboMvmerkListAPI(filter);
	}
}
