import 'package:joss_app/apis/gen_status_aset/statusasetcari_api.dart';
import 'package:joss_app/models/gen_status_aset/statusasetcari_model.dart';

class StatusAsetCariRepository {

	Future<List<StatusAsetCariModel>> getStatusAsetCari() async {
		StatusAsetCariAPI api = StatusAsetCariAPI();
		return await api.getStatusAsetCariAPI();
	}
}
