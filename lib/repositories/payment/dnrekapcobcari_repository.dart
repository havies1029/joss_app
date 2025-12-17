import 'package:joss_app/apis/payment/dnrekapcobcari_api.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

class DnrekapcobCariRepository {

	Future<List<DnrekapcobCariModel>> getDnrekapcobCari() async {
		DnrekapcobCariAPI api = DnrekapcobCariAPI();
		return await api.getDnrekapcobCariAPI();
	}
}
