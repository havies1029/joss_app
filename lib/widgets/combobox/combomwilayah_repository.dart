import 'package:joss_app/apis/combobox/combomwilayah_api.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class ComboMWilayahRepository {

	Future<List<ComboMWilayahModel>> getComboMWilayah() async {
		ComboMWilayahAPI api = ComboMWilayahAPI();
		return await api.getComboMWilayahAPI();
	}
}
