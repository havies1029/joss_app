import 'package:joss_app/apis/gen_berita/berita1cari_api.dart';
import 'package:joss_app/models/gen_berita/berita1cari_model.dart';

class Berita1CariRepository {

	Future<List<Berita1CariModel>> getBerita1Cari(int jenis, int hal) async {
		Berita1CariAPI api = Berita1CariAPI();
		return await api.getBerita1CariAPI(jenis, hal);
	}
}
