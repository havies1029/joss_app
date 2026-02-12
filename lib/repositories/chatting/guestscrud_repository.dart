import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/chatting/guestscrud_api.dart';
import 'package:joss_app/models/chatting/guestscrud_model.dart';

class GuestsCrudRepository {

	GuestsCrudAPI api = GuestsCrudAPI();

	Future<ReturnDataAPI> guestsCrudTambah(GuestsCrudModel record) async {
		return await api.guestsCrudTambahAPI(record);
	}
	Future<bool> guestsCrudUbah(GuestsCrudModel record) async {
		return await api.guestsCrudUbahAPI(record);
	}
	Future<bool> guestsCrudHapus(String guestsId) async {
		return await api.guestsCrudHapusAPI(guestsId);
	}
	Future<GuestsCrudModel> guestsCrudLihat(String guestsId) async {
		return await api.guestsCrudLihatAPI(guestsId);
	}
}
