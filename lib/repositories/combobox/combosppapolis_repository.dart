import 'package:joss_app/apis/combobox/combosppapolis_api.dart';
import 'package:joss_app/models/combobox/combosppapolis_model.dart';

class ComboSppaPolisRepository {

	Future<List<ComboSppaPolisModel>> getComboSppaPolis(String filter) async {
		ComboSppaPolisAPI api = ComboSppaPolisAPI();
		return await api.getComboSppaPolisAPI(filter);
	}
}
