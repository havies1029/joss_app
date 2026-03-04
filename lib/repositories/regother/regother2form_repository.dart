import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regother/regother2form_api.dart';
import 'package:joss_app/models/regother/regother2form_model.dart';

class Regother2FormRepository {

	Regother2FormAPI api = Regother2FormAPI();

	Future<ReturnDataAPI> regother2FormTambah(Regother2FormModel record) async {
		return await api.regother2FormTambahAPI(record);
	}
	Future<bool> regother2FormUbah(Regother2FormModel record) async {
		return await api.regother2FormUbahAPI(record);
	}
	Future<bool> regother2FormHapus(String regother2Id) async {
		return await api.regother2FormHapusAPI(regother2Id);
	}
	Future<Regother2FormModel> regother2FormLihat(String regother2Id) async {
		return await api.regother2FormLihatAPI(regother2Id);
	}
}
