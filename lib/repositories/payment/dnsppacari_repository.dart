import 'package:joss_app/apis/payment/dnsppacari_api.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';

class DnsppaCariRepository {

	Future<List<DnsppaCariModel>> getDnsppaCari(String listcobId, String currId, String searchText, int hal) async {
		DnsppaCariAPI api = DnsppaCariAPI();
		return await api.getDnsppaCariAPI(listcobId, currId, searchText, hal);
	}
}
