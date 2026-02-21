import 'package:joss_app/apis/combobox/comborokupasi_api.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class ComboROkupasiRepository {

	Future<List<ComboROkupasiModel>> getComboROkupasi(String filter) async {
		ComboROkupasiAPI api = ComboROkupasiAPI();
		return await api.getComboROkupasiAPI(filter);
	}
}
