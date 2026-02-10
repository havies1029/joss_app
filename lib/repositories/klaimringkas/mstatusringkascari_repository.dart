import 'package:joss_app/apis/klaimringkas/mstatusringkascari_api.dart';
import 'package:joss_app/models/klaimringkas/mstatusringkascari_model.dart';

class MstatusringkasCariRepository {

	Future<List<MstatusringkasCariModel>> getMstatusringkasCari() async {
		MstatusringkasCariAPI api = MstatusringkasCariAPI();
		return await api.getMstatusringkasCariAPI();
	}
}
