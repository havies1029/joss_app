import 'package:joss_app/apis/regrenewal/regrenewcari_api.dart';
import 'package:joss_app/models/regrenewal/regrenewcari_model.dart';

class RegrenewCariRepository {

	Future<List<RegrenewCariModel>> getRegrenewCari(String searchText, int hal) async {
		RegrenewCariAPI api = RegrenewCariAPI();
		return await api.getRegrenewCariAPI(searchText, hal);
	}
}
