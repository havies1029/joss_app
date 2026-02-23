//generate from : usp_flutter_crud_repository

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/klaimbatal/klaimbatalcrud_api.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';

class KlaimbatalcrudRepository {

	KlaimbatalcrudAPI api = KlaimbatalcrudAPI();

	Future<bool> klaimbatalcrudUbah(KlaimbatalcrudModel record) async {
		return await api.klaimbatalcrudUbahAPI(record);
	}
}
