import 'package:joss_app/apis/regklaim/sppaheader_api.dart';
import 'package:joss_app/models/regklaim/sppaheader_model.dart';

class SppaHeaderRepository {

	SppaHeaderAPI api = SppaHeaderAPI();

	Future<SppaHeaderModel> sppaHeaderLihat(String sppa1Id) async {
		return await api.sppaHeaderLihatAPI(sppa1Id);
	}
}
