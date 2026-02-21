import 'package:joss_app/apis/combobox/combomjnskel_api.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';

class ComboMJnskelRepository {

	Future<List<ComboMJnskelModel>> getComboMJnskel() async {
		ComboMJnskelAPI api = ComboMJnskelAPI();
		return await api.getComboMJnskelAPI();
	}
}
