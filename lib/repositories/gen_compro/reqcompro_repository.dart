import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_compro/reqcompro_api.dart';
import 'package:joss_app/models/gen_compro/reqcompro_model.dart';

class ReqComproRepository {

	ReqComproAPI api = ReqComproAPI();

	Future<ReturnDataAPI> reqComproTambah(ReqComproModel record) async {
		return await api.reqComproTambahAPI(record);
	}	
}
