import 'package:joss_app/apis/combobox/combommvmodel_api.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';

class ComboMMvmodelRepository {

	Future<List<ComboMMvmodelModel>> getComboMMvmodel(String mvtipeId, String filter) async {
		ComboMMvmodelAPI api = ComboMMvmodelAPI(); return await api.getComboMMvmodelAPI(mvtipeId, filter); }
}
