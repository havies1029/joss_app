import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/reguser/reguser_api.dart';
import 'package:joss_app/models/reguser/reguser_model.dart';

class RegUserRepository {

	RegUserAPI api = RegUserAPI();

	Future<ReturnDataAPI> regUserTambah(RegUserModel record) async {
		return await api.regUserTambahAPI(record);
	}
	Future<bool> regUserUbah(RegUserModel record) async {
		return await api.regUserUbahAPI(record);
	}
	Future<bool> regUserHapus(String reguserId) async {
		return await api.regUserHapusAPI(reguserId);
	}
	Future<RegUserModel> regUserLihat(String reguserId) async {
		return await api.regUserLihatAPI(reguserId);
	}

  Future<ReturnDataAPI> validasiPinHP(RegUserModel record) async {
    return await api.validasiPinHP(record);
  }
}
