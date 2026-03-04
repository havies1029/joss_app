import 'package:joss_app/apis/combobox/combomjnsclient_api.dart';
import 'package:joss_app/models/combobox/combomjnsclient_model.dart';

class ComboMJnsclientRepository {

	Future<List<ComboMJnsclientModel>> getComboMJnsclient() async {
		ComboMJnsclientAPI api = ComboMJnsclientAPI();
		return await api.getComboMJnsclientAPI();
	}
}
