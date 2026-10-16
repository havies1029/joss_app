import 'package:joss_app/apis/gen_profile/mrekanpic_contact_change_api.dart';
import 'package:joss_app/models/gen_profile/mrekanpic_contact_change_model.dart';

class MRekanPicContactChangeRepository {
  final MRekanPicContactChangeApi api;

  MRekanPicContactChangeRepository({MRekanPicContactChangeApi? api})
      : api = api ?? MRekanPicContactChangeApi();

  Future<MRekanPicContactChangeResult> send(
    MRekanPicContactChangeSendModel record,
  ) {
    return api.send(record);
  }

  Future<MRekanPicContactChangeResult> validate(
    MRekanPicContactChangeValidateModel record,
  ) {
    return api.validate(record);
  }

  Future<MRekanPicContactChangeResult> prepare(
    MRekanPicContactChangePrepareModel record,
  ) {
    return api.prepare(record);
  }
}
