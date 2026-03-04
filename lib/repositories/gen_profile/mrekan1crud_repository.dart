import 'package:joss_app/apis/gen_profile/mrekan1crud_api.dart';
import 'package:joss_app/models/gen_profile/mrekan1crud_model.dart';

class MRekan1CrudRepository {
  MRekan1CrudAPI api = MRekan1CrudAPI();

  Future<MRekan1CrudModel> mRekan1CrudLihat() async {
    return await api.mRekan1CrudLihatAPI();
  }

  Future<bool> mRekan1SetujuTC(String mrekanId) async {
    return await api.mRekan1SetujuTCAPI(mrekanId);
  }
}
