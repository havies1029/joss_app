import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/perbaruiklaimmv/klaimmvklaimcrud_api.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvklaimcrud_model.dart';

class KlaimmvklaimcrudRepository {

	KlaimmvklaimcrudAPI api = KlaimmvklaimcrudAPI();

	Future<ReturnDataAPI> klaimmvklaimcrudTambah(KlaimmvklaimcrudModel record) async {
		return await api.klaimmvklaimcrudTambahAPI(record);
	}
	Future<bool> klaimmvklaimcrudUbah(KlaimmvklaimcrudModel record) async {
		return await api.klaimmvklaimcrudUbahAPI(record);
	}
	Future<bool> klaimmvklaimcrudHapus(String klaim1Id) async {
		return await api.klaimmvklaimcrudHapusAPI(klaim1Id);
	}
	Future<KlaimmvklaimcrudModel?> klaimmvklaimcrudLihat(String klaim1Id) async {
		return await api.klaimmvklaimcrudLihatAPI(klaim1Id);
	}
}
