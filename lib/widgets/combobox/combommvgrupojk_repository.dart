import 'package:joss_app/apis/combobox/combommvgrupojk_api.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';

class ComboMMvgrupOjkRepository {

	Future<List<ComboMMvgrupOjkModel>> getComboMMvgrupOjk() async {
		ComboMMvgrupOjkAPI api = ComboMMvgrupOjkAPI();
		return await api.getComboMMvgrupOjkAPI();
	}
}
