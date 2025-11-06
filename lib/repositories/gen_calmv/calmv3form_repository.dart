import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_calmv/calmv3form_api.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';

class Calmv3FormRepository {

	Calmv3FormAPI api = Calmv3FormAPI();

	Future<ReturnDataAPI> calmv3FormTambah(Calmv3FormModel record) async {
		return await api.calmv3FormTambahAPI(record);
	}
	Future<bool> calmv3FormUbah(Calmv3FormModel record) async {
		return await api.calmv3FormUbahAPI(record);
	}
	Future<bool> calmv3FormHapus(String calmv3Id) async {
		return await api.calmv3FormHapusAPI(calmv3Id);
	}
	Future<Calmv3FormModel> calmv3FormLihat(String calmv3Id) async {
		return await api.calmv3FormLihatAPI(calmv3Id);
	}
}
