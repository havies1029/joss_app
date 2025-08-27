import 'package:joss_app/apis/combobox/combombidang_api.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';

class ComboMBidangRepository {

	Future<List<ComboMBidangModel>> getComboMBidang() async {
		ComboMBidangAPI api = ComboMBidangAPI();
		return await api.getComboMBidangAPI();
	}
}
