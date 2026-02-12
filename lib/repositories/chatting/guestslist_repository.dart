import 'package:joss_app/apis/chatting/guestslist_api.dart';
import 'package:joss_app/models/chatting/guestslist_model.dart';

class GuestsListRepository {

	Future<List<GuestsListModel>> getGuestsList(String searchText, int hal) async {
		GuestsListAPI api = GuestsListAPI();
		return await api.getGuestsListAPI(searchText, hal);
	}
}
