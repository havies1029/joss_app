import 'package:joss_app/apis/hakakses/hakaksescrud_api.dart';
import 'package:joss_app/models/hakakses/hakaksescrud_model.dart';

class HakaksesCrudRepository {

	HakaksesCrudAPI api = HakaksesCrudAPI();

	Future<HakaksesCrudModel> hakaksesCrudLihat() async {
		return await api.hakaksesCrudLihatAPI();
	}
}
