import 'package:joss_app/apis/gen_berita/berita3cari_api.dart';
import 'package:joss_app/models/gen_berita/berita3cari_model.dart';

class Berita3CariRepository {

	Future<List<Berita3CariModel>> getBerita3Cari(String berita1Id) async {
		Berita3CariAPI api = Berita3CariAPI();
		return await api.getBerita3CariAPI(berita1Id);
	}
}
