import 'package:joss_app/apis/combobox/combomtarifojkbanjirpar_api.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';

class ComboMTarifojkBanjirParRepository {

	Future<List<ComboMTarifojkBanjirParModel>> getComboMTarifojkBanjirPar() async {
		ComboMTarifojkBanjirParAPI api = ComboMTarifojkBanjirParAPI();
		return await api.getComboMTarifojkBanjirParAPI();
	}
}
