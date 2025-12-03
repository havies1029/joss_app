import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv7form_api.dart';
import 'package:joss_app/models/gen_regmv/regmv7form_model.dart';

class Regmv7FormRepository {

	Regmv7FormAPI api = Regmv7FormAPI();

	Future<ReturnDataAPI> regmv7FormTambah(Regmv7FormModel record) async {
		return await api.regmv7FormTambahAPI(record);
	}
	Future<bool> regmv7FormUbah(Regmv7FormModel record) async {
		return await api.regmv7FormUbahAPI(record);
	}
	Future<bool> regmv7FormHapus(String regmv7Id) async {
		return await api.regmv7FormHapusAPI(regmv7Id);
	}
	Future<Regmv7FormModel> regmv7FormLihat(String regmv7Id) async {
		return await api.regmv7FormLihatAPI(regmv7Id);
	}
}
