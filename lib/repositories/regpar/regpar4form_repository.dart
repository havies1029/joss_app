import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar4form_api.dart';
import 'package:joss_app/models/regpar/regpar4form_model.dart';

class Regpar4FormRepository {

	Regpar4FormAPI api = Regpar4FormAPI();

	Future<ReturnDataAPI> regpar4FormTambah(Regpar4FormModel record) async {
		return await api.regpar4FormTambahAPI(record);
	}
	Future<bool> regpar4FormUbah(Regpar4FormModel record) async {
		return await api.regpar4FormUbahAPI(record);
	}
	Future<bool> regpar4FormHapus(String regpar4Id) async {
		return await api.regpar4FormHapusAPI(regpar4Id);
	}
	Future<Regpar4FormModel> regpar4FormLihat(String regpar4Id) async {
		return await api.regpar4FormLihatAPI(regpar4Id);
	}
}
