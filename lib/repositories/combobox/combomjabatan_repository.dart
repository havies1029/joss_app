import 'package:joss_app/apis/combobox/combomjabatan_api.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';

class ComboMJabatanRepository {

	Future<List<ComboMJabatanModel>> getComboMJabatan() async {
		ComboMJabatanAPI api = ComboMJabatanAPI();
		return await api.getComboMJabatanAPI();
	}
}
