import 'package:joss_app/apis/chatting/messageslist_api.dart';
import 'package:joss_app/models/chatting/messageslist_model.dart';

class MessagesListRepository {

	Future<List<MessagesListModel>> getMessagesList(String searchText, int hal) async {
		MessagesListAPI api = MessagesListAPI();
		return await api.getMessagesListAPI(searchText, hal);
	}
}
