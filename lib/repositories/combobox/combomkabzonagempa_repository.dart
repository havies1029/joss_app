import 'package:joss_app/apis/combobox/combomkabzonagempa_api.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';

class ComboMKabZonaGempaRepository {

	Future<List<ComboMKabZonaGempaModel>> getComboMKabZonaGempa(String wilayahId, String searchText) async {
		ComboMKabZonaGempaAPI api = ComboMKabZonaGempaAPI();
		return await api.getComboMKabZonaGempaAPI(wilayahId, searchText);
	}
}
