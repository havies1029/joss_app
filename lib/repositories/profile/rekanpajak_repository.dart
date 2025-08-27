import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/profile/rekanpajak_api.dart';
import 'package:joss_app/models/profile/rekanpajak_model.dart';

class RekanPajakRepository {

	RekanPajakAPI api = RekanPajakAPI();

	Future<ReturnDataAPI> rekanPajakTambah(RekanPajakModel record) async {
		return await api.rekanPajakTambahAPI(record);
	}
	Future<bool> rekanPajakUbah(RekanPajakModel record) async {
		return await api.rekanPajakUbahAPI(record);
	}
	Future<bool> rekanPajakHapus(String mrekanpajakId) async {
		return await api.rekanPajakHapusAPI(mrekanpajakId);
	}
	Future<RekanPajakModel> rekanPajakLihat(String mrekanpajakId) async {
		return await api.rekanPajakLihatAPI(mrekanpajakId);
	}
}
