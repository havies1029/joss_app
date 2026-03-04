import 'package:joss_app/apis/gallery/gallerytestimonycari_api.dart';
import 'package:joss_app/models/gallery/gallerytestimonycari_model.dart';

class GallerytestimonyCariRepository {

	Future<List<GallerytestimonyCariModel>> getGallerytestimonyCari() async {
		GallerytestimonyCariAPI api = GallerytestimonyCariAPI();
		return await api.getGallerytestimonyCariAPI();
	}
}
