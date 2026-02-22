import 'package:joss_app/apis/notiflog/logtrscari_api.dart';
import 'package:joss_app/models/notiflog/logtrscari_model.dart';

class LogtrscariRepository {

	Future<List<LogtrscariModel>> getLogtrscari(String groupLogId, int hal) async {
		LogtrscariAPI api = LogtrscariAPI();
		return await api.getLogtrscariAPI(groupLogId, hal);
	}

  Future<List<LogtrscariModel>> getLogtrscaritopx() async {
    LogtrscariAPI api = LogtrscariAPI();
    return await api.getLogtrscaritopxAPI();
  }
}
