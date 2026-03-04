import 'package:joss_app/apis/gen_dn1/dn1cari_api.dart';
import 'package:joss_app/models/gen_dn1/dn1cari_model.dart';

class Dn1CariRepository {
	Future<List<Dn1CariModel>> getDn1Cari(String sppa1Id) async {
		Dn1CariAPI api = Dn1CariAPI();

		print("📡 [Repository] Requesting DN1 list for sppa1Id=$sppa1Id ...");

		final result = await api.getDn1CariAPI(sppa1Id);

		print("📦 [Repository] Received ${result.length} items from API");
		if (result.isNotEmpty) {
			print("🧩 Sample item: ${result.first.toJson()}");
		} else {
			print("⚠️ [Repository] No data returned (empty list)");
		}

		return result;
	}
}
