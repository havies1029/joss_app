import 'package:joss_app/apis/combobox/combompekerjaan_api.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';

class ComboMPekerjaanRepository {

	Future<List<ComboMPekerjaanModel>> getComboMPekerjaan() async {
		ComboMPekerjaanAPI api = ComboMPekerjaanAPI();
		return await api.getComboMPekerjaanAPI();
	}
}
