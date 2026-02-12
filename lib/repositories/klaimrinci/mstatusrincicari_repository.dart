import 'package:joss_app/apis/klaimrinci/mstatusrincicari_api.dart';
import 'package:joss_app/models/klaimrinci/mstatusrincicari_model.dart';

class MstatusrinciCariRepository {

	Future<List<MstatusrinciCariModel>> getMstatusrinciCari() async {
		MstatusrinciCariAPI api = MstatusrinciCariAPI();
		return await api.getMstatusrinciCariAPI();
	}
}
