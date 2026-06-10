import 'package:joss_app/apis/combobox/combomjenisrugimv_api.dart';
import 'package:joss_app/models/combobox/combomjenisrugimv_model.dart';

class ComboMJenisrugimvRepository {

	Future<List<ComboMJenisrugimvModel>> getComboMJenisrugimv() async {
		ComboMJenisrugimvAPI api = ComboMJenisrugimvAPI();
		return await api.getComboMJenisrugimvAPI();
	}
}
