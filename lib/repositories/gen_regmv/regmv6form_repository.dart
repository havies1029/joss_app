import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv6form_api.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';

class Regmv6FormRepository {
	Regmv6FormAPI api = Regmv6FormAPI();

	Future<ReturnDataAPI> regmv6FormTambah(Regmv6FormModel record) async {
		return await api.regmv6FormTambahAPI(record);
	}

	Future<bool> regmv6FormUbah(Regmv6FormModel record) async {
		return await api.regmv6FormUbahAPI(record);
	}

	Future<bool> regmv6FormHapus(String regmv6Id) async {
		return await api.regmv6FormHapusAPI(regmv6Id);
	}

	Future<Regmv6FormModel> regmv6FormLihat(String regmv6Id) async {
		return await api.regmv6FormLihatAPI(regmv6Id);
	}

	Future<Regmv6FormModel> calPremiRegMv(String regmv1Id) async {
		return await api.calPremiRegMvAPI(regmv1Id);
	}
}
