import 'package:joss_app/apis/gen_detail_sts_sppa/mdetailstssppacari_api.dart';
import 'package:joss_app/models/gen_detail_sts_sppa/mdetailstssppacari_model.dart';

class MDetailStsSppaCariRepository {
  Future<List<MDetailStsSppaCariModel>> getMDetailStsSppaCari() async {
    MDetailStsSppaCariAPI api = MDetailStsSppaCariAPI();
    return await api.getMDetailStsSppaCariAPI();
  }
}
