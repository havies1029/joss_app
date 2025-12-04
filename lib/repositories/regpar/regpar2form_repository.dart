import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regpar/regpar2form_api.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';

class Regpar2FormRepository {

	Regpar2FormAPI api = Regpar2FormAPI();

	Future<ReturnDataAPI> regpar2FormTambah(Regpar2FormModel record) async {
		return await api.regpar2FormTambahAPI(record);
	}

	Future<bool> regpar2FormUbah(Regpar2FormModel record) async {
		return await api.regpar2FormUbahAPI(record);
	}

	Future<bool> regpar2FormHapus(String regpar2Id) async {
		return await api.regpar2FormHapusAPI(regpar2Id);
	}

	Future<Regpar2FormModel> regpar2FormLihat(String regpar1Id) async {
		return await api.regpar2FormLihatAPI(regpar1Id);
	}
}
