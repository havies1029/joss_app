import 'package:joss_app/apis/payment/dnsppamvcari_api.dart';
import 'package:joss_app/models/payment/dnsppamvcari_model.dart';

class DnsppamvCariRepository {

	Future<List<DnsppamvCariModel>> getDnsppamvCari(String sppa1Id, String searchText, int hal) async {
		DnsppamvCariAPI api = DnsppamvCariAPI();
		return await api.getDnsppamvCariAPI(sppa1Id, searchText, hal);
	}
}
