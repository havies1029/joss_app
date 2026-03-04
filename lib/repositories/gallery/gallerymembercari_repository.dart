import 'package:joss_app/apis/gallery/gallerymembercari_api.dart';
import 'package:joss_app/models/gallery/gallerymembercari_model.dart';

class GallerymemberCariRepository {

	Future<List<GallerymemberCariModel>> getGallerymemberCari() async {
		GallerymemberCariAPI api = GallerymemberCariAPI();
		return await api.getGallerymemberCariAPI();
	}
}
