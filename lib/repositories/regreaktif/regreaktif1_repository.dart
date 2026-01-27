import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/regreaktif/regreaktif1_api.dart';
import 'package:joss_app/models/regreaktif/regreaktif1_model.dart';

class Regreaktif1Repository {

	Regreaktif1API api = Regreaktif1API();

	Future<ReturnDataAPI> regreaktif1Tambah(Regreaktif1Model record) async {
		return await api.regreaktif1TambahAPI(record);
	}
	Future<bool> regreaktif1Ubah(Regreaktif1Model record) async {
		return await api.regreaktif1UbahAPI(record);
	}
	Future<bool> regreaktif1Hapus(String regreaktif1Id) async {
		return await api.regreaktif1HapusAPI(regreaktif1Id);
	}
	Future<Regreaktif1Model> regreaktif1Lihat(String regreaktif1Id) async {
		return await api.regreaktif1LihatAPI(regreaktif1Id);
	}
}
