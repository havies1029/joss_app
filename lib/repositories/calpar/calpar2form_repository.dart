import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/calpar/calpar2form_api.dart';
import 'package:joss_app/models/calpar/calpar2form_model.dart';

class Calpar2FormRepository {

	Calpar2FormAPI api = Calpar2FormAPI();

	Future<ReturnDataAPI> calpar2FormTambah(Calpar2FormModel record) async {
		return await api.calpar2FormTambahAPI(record);
	}
	Future<bool> calpar2FormUbah(Calpar2FormModel record) async {
		return await api.calpar2FormUbahAPI(record);
	}
	Future<bool> calpar2FormHapus(String calpar2Id) async {
		return await api.calpar2FormHapusAPI(calpar2Id);
	}
	Future<Calpar2FormModel> calpar2FormLihat(String calpar2Id) async {
		return await api.calpar2FormLihatAPI(calpar2Id);
	}
}
