import 'package:joss_app/apis/combobox/combombank_api.dart';
import 'package:joss_app/models/combobox/combombank_model.dart';

class ComboMBankRepository {

	Future<List<ComboMBankModel>> getComboMBank() async {
		ComboMBankAPI api = ComboMBankAPI();
		return await api.getComboMBankAPI();
	}
}
