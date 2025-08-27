import 'package:joss_app/apis/gen_cob_app/cobcari_api.dart';
import 'package:joss_app/models/gen_cob_app/cobcari_model.dart';

class CobCariRepository {

	Future<List<CobCariModel>> getCobCari() async {
		CobCariAPI api = CobCariAPI();
		return await api.getCobCariAPI();
	}
}
