import 'package:joss_app/apis/klaimlacak/klaimprogresscari_api.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';

class KlaimprogresscariRepository {

	Future<KlaimprogressCariResultModel?> getKlaimprogresscari(String klaim1Id) async {
		KlaimprogresscariAPI api = KlaimprogresscariAPI();
		return await api.getKlaimprogresscariAPI(klaim1Id);
	}
}
