import 'package:joss_app/apis/combobox/combowarnalist_api.dart';
import 'package:joss_app/models/combobox/combowarnalist_model.dart';

class ComboWarnaListRepository {

	Future<List<ComboWarnaListModel>> getComboWarnaList(String filter) async {
		ComboWarnaListAPI api = ComboWarnaListAPI();
		return await api.getComboWarnaListAPI(filter);
	}
}
