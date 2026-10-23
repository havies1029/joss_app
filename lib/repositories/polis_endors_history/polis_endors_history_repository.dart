import 'package:joss_app/apis/polis_endors_history/polis_endors_history_api.dart';
import 'package:joss_app/models/polis_endors_history/polis_endors_history_model.dart';

class PolisEndorsHistoryRepository {
  final PolisEndorsHistoryApi _api;

  PolisEndorsHistoryRepository({PolisEndorsHistoryApi? api})
      : _api = api ?? PolisEndorsHistoryApi();

  Future<List<PolisEndorsHistoryModel>> getPolisEndorsHistory({
    required PolisEndorsHistoryCob cob,
    required String polis2Id,
    String searchText = '',
    int hal = 0,
  }) {
    return _api.getPolisEndorsHistory(
      cob: cob,
      polis2Id: polis2Id,
      searchText: searchText,
      hal: hal,
    );
  }
}
