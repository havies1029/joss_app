import 'package:joss_app/apis/combobox/combombengkel_api.dart';
import 'package:joss_app/models/combobox/combombengkel_model.dart';

class ComboMBengkelRepository {

	Future<List<ComboMBengkelModel>> getComboMBengkel(String mwilayahbengkelId, String filter) async {
		ComboMBengkelAPI api = ComboMBengkelAPI();
		return await api.getComboMBengkelAPI(mwilayahbengkelId, filter);
	}
}
