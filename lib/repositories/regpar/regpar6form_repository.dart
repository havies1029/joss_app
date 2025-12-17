import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar6form_api.dart';
import 'package:joss_app/models/regpar/regpar6form_model.dart';

class Regpar6FormRepository {

	Regpar6FormAPI api = Regpar6FormAPI();

	Future<ReturnDataAPI> regpar6FormTambah(Regpar6FormModel record) async {
		return await api.regpar6FormTambahAPI(record);
	}
	Future<bool> regpar6FormUbah(Regpar6FormModel record) async {
		return await api.regpar6FormUbahAPI(record);
	}
	Future<bool> regpar6FormHapus(String regpar6Id) async {
		return await api.regpar6FormHapusAPI(regpar6Id);
	}
	Future<Regpar6FormModel> regpar6FormLihat(String regpar6Id) async {
		return await api.regpar6FormLihatAPI(regpar6Id);
	}
}
