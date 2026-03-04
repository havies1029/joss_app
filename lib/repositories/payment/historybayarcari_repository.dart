import 'package:joss_app/apis/payment/historybayarcari_api.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';

class HistorybayarCariRepository {

	Future<List<HistorybayarCariModel>> getHistorybayarCari(String statusId, String searchText, int hal) async {
		HistorybayarCariAPI api = HistorybayarCariAPI();
		return await api.getHistorybayarCariAPI(statusId, searchText, hal);
	}
}
