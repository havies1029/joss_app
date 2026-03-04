import 'package:joss_app/apis/gallery/galleryeventcari_api.dart';
import 'package:joss_app/models/gallery/galleryeventcari_model.dart';

class GalleryeventCariRepository {

	Future<List<GalleryeventCariModel>> getGalleryeventCari() async {
		GalleryeventCariAPI api = GalleryeventCariAPI();
		return await api.getGalleryeventCariAPI();
	}
}
