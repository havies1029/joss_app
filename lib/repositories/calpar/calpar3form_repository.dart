import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/calpar/calpar3form_api.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';

class Calpar3FormRepository {

	Calpar3FormAPI api = Calpar3FormAPI();

	Future<ReturnDataAPI> calpar3FormTambah(Calpar3FormModel record) async {
		return await api.calpar3FormTambahAPI(record);
	}
	Future<bool> calpar3FormUbah(Calpar3FormModel record) async {
		return await api.calpar3FormUbahAPI(record);
	}
	Future<bool> calpar3FormHapus(String calpar3Id) async {
		return await api.calpar3FormHapusAPI(calpar3Id);
	}
	Future<Calpar3FormModel> calpar3FormLihat(String calpar1Id) async {
		return await api.calpar3FormLihatAPI(calpar1Id);
	}
}