import 'package:joss_app/apis/regreaktif/regreaktifcari_api.dart';
import 'package:joss_app/models/regreaktif/regreaktifcari_model.dart';

class RegreaktifCariRepository {

	Future<List<RegreaktifCariModel>> getRegreaktifCari(String searchText, int hal) async {
		RegreaktifCariAPI api = RegreaktifCariAPI();
		return await api.getRegreaktifCariAPI(searchText, hal);
	}
}
