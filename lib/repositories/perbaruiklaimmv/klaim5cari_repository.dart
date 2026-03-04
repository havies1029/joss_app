import 'package:joss_app/apis/perbaruiklaimmv/klaim5cari_api.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';

class Klaim5cariRepository {

	Future<List<Klaim5cariModel>> getKlaim5cari(String klaim1Id) async {
		Klaim5cariAPI api = Klaim5cariAPI();
		return await api.getKlaim5cariAPI(klaim1Id);
	}
}
