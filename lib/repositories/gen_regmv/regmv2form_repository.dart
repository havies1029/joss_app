import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv2form_api.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';

class Regmv2FormRepository {

	Regmv2FormAPI api = Regmv2FormAPI();

	Future<ReturnDataAPI> regmv2FormTambah(Regmv2FormModel record) async {
		return await api.regmv2FormTambahAPI(record);
	}
	Future<bool> regmv2FormUbah(Regmv2FormModel record) async {
		return await api.regmv2FormUbahAPI(record);
	}
	Future<bool> regmv2FormHapus(String regmv2Id) async {
		return await api.regmv2FormHapusAPI(regmv2Id);
	}
	Future<Regmv2FormModel> regmv2FormLihat(String regmv2Id) async {
		return await api.regmv2FormLihatAPI(regmv2Id);
	}
}
