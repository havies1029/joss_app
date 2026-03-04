
import 'package:joss_app/apis/onboardmenu/onboardmenucari_api.dart';
import 'package:joss_app/models/onboardmenu/onboardmenucari_model.dart';

class OnBoardMenuCariRepository {

	Future<OnBoardMenuCariModel> getOnBoardMenuCari() async {
		OnBoardMenuCariAPI api = OnBoardMenuCariAPI();
		return await api.getOnBoardMenuCariAPI();
	}
}
