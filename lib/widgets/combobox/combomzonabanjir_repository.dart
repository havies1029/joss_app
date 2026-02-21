import 'package:joss_app/apis/combobox/combomzonabanjir_api.dart';
import 'package:joss_app/models/combobox/combomzonabanjir_model.dart';

class ComboMZonaBanjirRepository {

	Future<List<ComboMZonaBanjirModel>> getComboMZonaBanjir() async {
		ComboMZonaBanjirAPI api = ComboMZonaBanjirAPI();
		return await api.getComboMZonaBanjirAPI();
	}
}
