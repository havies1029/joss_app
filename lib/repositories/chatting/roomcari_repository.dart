import 'package:joss_app/apis/chatting/roomcari_api.dart';
import 'package:joss_app/models/chatting/roomcari_model.dart';

class RoomCariRepository {

	Future<List<RoomCariModel>> getRoomCari(String searchText, int hal) async {
		return await getRoomCariAPI(searchText, hal);
	}
}
