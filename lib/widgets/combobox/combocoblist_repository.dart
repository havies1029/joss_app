import 'package:joss_app/apis/combobox/combocoblist_api.dart';
import 'package:joss_app/models/combobox/combocoblist_model.dart';

class ComboCobListRepository {

	Future<List<ComboCobListModel>> getComboCobList() async {
		ComboCobListAPI api = ComboCobListAPI();
		return await api.getComboCobListAPI();
	}
}
