import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/profile/rekanbank_api.dart';
import 'package:joss_app/models/profile/rekanbank_model.dart';

class RekanBankRepository {

	RekanBankAPI api = RekanBankAPI();

	Future<ReturnDataAPI> rekanBankTambah(RekanBankModel record) async {
		return await api.rekanBankTambahAPI(record);
	}
	Future<bool> rekanBankUbah(RekanBankModel record) async {
		return await api.rekanBankUbahAPI(record);
	}
	Future<bool> rekanBankHapus(String mrekanbankId) async {
		return await api.rekanBankHapusAPI(mrekanbankId);
	}
	Future<RekanBankModel> rekanBankLihat(String mrekanbankId) async {
		return await api.rekanBankLihatAPI(mrekanbankId);
	}
}
