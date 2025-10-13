import 'package:joss_app/apis/gen_profile/rekanpiccobcari_api.dart';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RekanPicCobCariRepository {

	Future<List<RekanPicCobCariModel>> getRekanPicCobCari(String rekanPicId, String searchText, int hal) async {
		RekanPicCobCariAPI api = RekanPicCobCariAPI();
		return await api.getRekanPicCobCariAPI(rekanPicId, searchText, hal);
	}

  Future<ReturnDataAPI> rekanPicCobUpdateList(
      String rekanPicId, List<RekanPicCobCariCheckboxModel> listChecked) async {
    RekanPicCobCariAPI api = RekanPicCobCariAPI();
    return api.rekanPicCobUpdateListAPI(rekanPicId, listChecked);
  }
}
