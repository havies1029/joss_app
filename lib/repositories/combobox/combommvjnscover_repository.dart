import 'package:joss_app/apis/combobox/combommvjnscover_api.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';

class ComboMMvjnscoverRepository {

	Future<List<ComboMMvjnscoverModel>> getComboMMvjnscover() async {
		ComboMMvjnscoverAPI api = ComboMMvjnscoverAPI();
		return await api.getComboMMvjnscoverAPI();
	}
}
