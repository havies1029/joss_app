import 'package:joss_app/apis/combobox/comborkonstruksiojk_api.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';

class ComboRKonstruksiojkRepository {

	Future<List<ComboRKonstruksiojkModel>> getComboRKonstruksiojk() async {
		ComboRKonstruksiojkAPI api = ComboRKonstruksiojkAPI();
		return await api.getComboRKonstruksiojkAPI();
	}
}
