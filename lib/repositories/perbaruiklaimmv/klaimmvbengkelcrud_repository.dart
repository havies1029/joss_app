import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/perbaruiklaimmv/klaimmvbengkelcrud_api.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvbengkelcrud_model.dart';

class KlaimmvbengkelcrudRepository {

	KlaimmvbengkelcrudAPI api = KlaimmvbengkelcrudAPI();

	Future<ReturnDataAPI> klaimmvbengkelcrudTambah(KlaimmvbengkelcrudModel record) async {
		return await api.klaimmvbengkelcrudTambahAPI(record);
	}
	Future<bool> klaimmvbengkelcrudUbah(KlaimmvbengkelcrudModel record) async {
		return await api.klaimmvbengkelcrudUbahAPI(record);
	}
	Future<bool> klaimmvbengkelcrudHapus(String klaim1Id) async {
		return await api.klaimmvbengkelcrudHapusAPI(klaim1Id);
	}
	Future<KlaimmvbengkelcrudModel?> klaimmvbengkelcrudLihat(String klaim1Id) async {
		return await api.klaimmvbengkelcrudLihatAPI(klaim1Id);
	}
}
