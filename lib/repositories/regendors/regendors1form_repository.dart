import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regendors/regendors1form_api.dart';
import 'package:joss_app/models/regendors/regendors1form_model.dart';

class Regendors1FormRepository {

	Regendors1FormAPI api = Regendors1FormAPI();

	Future<ReturnDataAPI> regendors1FormTambah(Regendors1FormModel record) async {
		return await api.regendors1FormTambahAPI(record);
	}
	Future<bool> regendors1FormUbah(Regendors1FormModel record) async {
		return await api.regendors1FormUbahAPI(record);
	}
	Future<bool> regendors1FormHapus(String regendors1Id) async {
		return await api.regendors1FormHapusAPI(regendors1Id);
	}
	Future<Regendors1FormModel> regendors1FormLihat(String regendors1Id) async {
		return await api.regendors1FormLihatAPI(regendors1Id);
	}
}
