import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar3form_api.dart';
import 'package:joss_app/models/regpar/regpar3form_model.dart';

class Regpar3FormRepository {

	Regpar3FormAPI api = Regpar3FormAPI();

	Future<ReturnDataAPI> regpar3FormTambah(Regpar3FormModel record) async {
		return await api.regpar3FormTambahAPI(record);
	}
	Future<bool> regpar3FormUbah(Regpar3FormModel record) async {
		return await api.regpar3FormUbahAPI(record);
	}
	Future<bool> regpar3FormHapus(String regpar3Id) async {
		return await api.regpar3FormHapusAPI(regpar3Id);
	}
	Future<Regpar3FormModel> regpar3FormLihat(String regpar3Id) async {
		return await api.regpar3FormLihatAPI(regpar3Id);
	}
}
