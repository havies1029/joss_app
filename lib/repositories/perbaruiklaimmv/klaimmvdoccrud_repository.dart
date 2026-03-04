//generate from : usp_flutter_crud_repository

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/perbaruiklaimmv/klaimmvdoccrud_api.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvdoccrud_model.dart';

class KlaimmvdoccrudRepository {

	KlaimmvdoccrudAPI api = KlaimmvdoccrudAPI();

	Future<ReturnDataAPI> klaimmvdoccrudTambah(KlaimmvdoccrudModel record) async {
		return await api.klaimmvdoccrudTambahAPI(record);
	}
	Future<bool> klaimmvdoccrudUbah(KlaimmvdoccrudModel record) async {
		return await api.klaimmvdoccrudUbahAPI(record);
	}
	Future<bool> klaimmvdoccrudHapus(String klaim1Id, String mjenisdocId, String jenisDocLain) async {
		return await api.klaimmvdoccrudHapusAPI(klaim1Id, mjenisdocId, jenisDocLain);
	}
	Future<KlaimmvdoccrudModel?> klaimmvdoccrudLihat(String klaim5Id) async {
		return await api.klaimmvdoccrudLihatAPI(klaim5Id);
	}
}
