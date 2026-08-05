import 'package:joss_app/apis/combobox/combomkecamatan_api.dart';
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';

class ComboMKecamatanRepository {

	Future<List<ComboMKecamatanModel>> getComboMKecamatan(String kotaId, [String searchText = '']) async {
		ComboMKecamatanAPI api = ComboMKecamatanAPI();
		return await api.getComboMKecamatanAPI(kotaId, searchText);
	}
}
