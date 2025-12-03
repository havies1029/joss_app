import 'package:joss_app/apis/combobox/combommvpakai_api.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
class ComboMMvpakaiRepository {

	Future<List<ComboMMvpakaiModel>> getComboMMvpakai() async {
		ComboMMvpakaiAPI api = ComboMMvpakaiAPI();
		return await api.getComboMMvpakaiAPI();
	}
}
