import 'package:joss_app/apis/logoclient/mlogoclientcari_api.dart';
import 'package:joss_app/models/logoclient/mlogoclientcari_model.dart';

class MlogoclientCariRepository {

	Future<List<MlogoclientCariModel>> getMlogoclientCari() async {
		MlogoclientCariAPI api = MlogoclientCariAPI();
		return await api.getMlogoclientCariAPI();
	}
}
