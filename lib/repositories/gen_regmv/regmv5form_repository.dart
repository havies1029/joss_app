import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv5form_api.dart';
import 'package:joss_app/models/gen_regmv/regmv5form_model.dart';

class Regmv5FormRepository {

	Regmv5FormAPI api = Regmv5FormAPI();

	Future<ReturnDataAPI> regmv5FormTambah(Regmv5FormModel record) async {
		return await api.regmv5FormTambahAPI(record);
	}
	Future<bool> regmv5FormUbah(Regmv5FormModel record) async {
		return await api.regmv5FormUbahAPI(record);
	}
	Future<bool> regmv5FormHapus(String regmv5Id) async {
		return await api.regmv5FormHapusAPI(regmv5Id);
	}
	Future<Regmv5FormModel> regmv5FormLihat(String regmv5Id) async {
		return await api.regmv5FormLihatAPI(regmv5Id);
	}
}
