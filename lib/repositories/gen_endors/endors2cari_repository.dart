import 'package:joss_app/apis/gen_endors/endors2cari_api.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';

class Endors2CariRepository {

	Future<List<Endors2CariModel>> getEndors2Cari() async {
		Endors2CariAPI api = Endors2CariAPI();
		return await api.getEndors2CariAPI();
	}
}
