import 'package:joss_app/apis/combobox/combomkelurahan_api.dart';
import 'package:joss_app/models/combobox/combomkelurahan_model.dart';

class ComboMKelurahanRepository {

	Future<List<ComboMKelurahanModel>> getComboMKelurahan(String kecamatanId) async {
		ComboMKelurahanAPI api = ComboMKelurahanAPI();
		return await api.getComboMKelurahanAPI(kecamatanId);
	}
}
