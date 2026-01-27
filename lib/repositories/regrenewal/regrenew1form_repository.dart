import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regrenewal/regrenew1form_api.dart';
import 'package:joss_app/models/regrenewal/regrenew1form_model.dart';

class Regrenew1FormRepository {

	Regrenew1FormAPI api = Regrenew1FormAPI();

	Future<ReturnDataAPI> regrenew1FormTambah(Regrenew1FormModel record) async {
		return await api.regrenew1FormTambahAPI(record);
	}
	Future<bool> regrenew1FormUbah(Regrenew1FormModel record) async {
		return await api.regrenew1FormUbahAPI(record);
	}
	Future<bool> regrenew1FormHapus(String regrenew1Id) async {
		return await api.regrenew1FormHapusAPI(regrenew1Id);
	}
	Future<Regrenew1FormModel> regrenew1FormLihat(String regrenew1Id) async {
		return await api.regrenew1FormLihatAPI(regrenew1Id);
	}
}
