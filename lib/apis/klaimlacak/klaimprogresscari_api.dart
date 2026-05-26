import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/helper/object_map_helper.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';

class KlaimprogresscariAPI{
	Future<KlaimprogressCariResultModel?> getKlaimprogresscariAPI(String klaim1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaimlacak/klaimprogresscari/getlist";

		Map<String, String> queryParams = {"klaim1Id": klaim1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {

			final jsonData = ObjectMapHelper().decodeJsonMapOrNull(response.body);
			if (jsonData == null) return null;

			var result = KlaimprogressCariResultModel.fromJson(jsonData);

			return result;
		} else {
			throw Exception("Failed to load data");
		}
	}

}
