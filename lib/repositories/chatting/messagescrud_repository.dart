import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/chatting/messagescrud_api.dart';
import 'package:joss_app/models/chatting/messagescrud_model.dart';

class MessagesCrudRepository {

	MessagesCrudAPI api = MessagesCrudAPI();

	Future<ReturnDataAPI> messagesCrudTambah(MessagesCrudModel record) async {
		return await api.messagesCrudTambahAPI(record);
	}
	Future<bool> messagesCrudUbah(MessagesCrudModel record) async {
		return await api.messagesCrudUbahAPI(record);
	}
	Future<bool> messagesCrudHapus(String id) async {
		return await api.messagesCrudHapusAPI(id);
	}
	Future<MessagesCrudModel> messagesCrudLihat(String id) async {
		return await api.messagesCrudLihatAPI(id);
	}
}
