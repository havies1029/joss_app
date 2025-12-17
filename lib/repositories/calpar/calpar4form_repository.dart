import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/calpar/calpar4form_api.dart';
import 'package:joss_app/models/calpar/calpar4form_model.dart';

class Calpar4FormRepository {

	Calpar4FormAPI api = Calpar4FormAPI();

	Future<ReturnDataAPI> calpar4FormTambah(Calpar4FormModel record) async {
		return await api.calpar4FormTambahAPI(record);
	}
	Future<bool> calpar4FormUbah(Calpar4FormModel record) async {
		return await api.calpar4FormUbahAPI(record);
	}
	Future<bool> calpar4FormHapus(String calpar4Id) async {
		return await api.calpar4FormHapusAPI(calpar4Id);
	}
	Future<Calpar4FormModel> calpar4FormLihat(String calpar1Id) async {
		return await api.calpar4FormLihatAPI(calpar1Id);
	}
	Future<Calpar4FormModel> calpar4FormHitungPremi(String calmv1Id) async {
		return await api.calpar4FormHitungPremiAPI(calmv1Id);
	}
}