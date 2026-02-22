import 'package:joss_app/apis/notifevent/notifeventcari_api.dart';
import 'package:joss_app/models/notifevent/notifeventcari_model.dart';

class NotifeventcariRepository {

	Future<List<NotifeventcariModel>> getNotifeventcari(int hal) async {
		NotifeventcariAPI api = NotifeventcariAPI();
		return await api.getNotifeventcariAPI(hal);
	}
}
