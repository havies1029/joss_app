import 'package:joss_app/apis/regklaim/polissourcecari_api.dart';
import 'package:joss_app/models/regklaim/polissourcecari_model.dart';

class PolissourcecariRepository {

	Future<List<PolissourcecariModel>> getPolissourcecari() async {
		PolissourcecariAPI api = PolissourcecariAPI();
		return await api.getPolissourcecariAPI();
	}
}
