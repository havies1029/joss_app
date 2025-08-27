import 'package:joss_app/apis/combobox/combommop_api.dart';
import 'package:joss_app/models/combobox/combommop_model.dart';

class ComboMMopRepository {

	Future<List<ComboMMopModel>> getComboMMop(String filter) async {
		ComboMMopAPI api = ComboMMopAPI();
		return await api.getComboMMopAPI(filter);
	}
}
