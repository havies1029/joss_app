import 'package:joss_app/apis/combobox/combormatauang_api.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';

class ComboRMatauangRepository {

	Future<List<ComboRMatauangModel>> getComboRMatauang() async {
		ComboRMatauangAPI api = ComboRMatauangAPI();
		return await api.getComboRMatauangAPI();
	}
}
