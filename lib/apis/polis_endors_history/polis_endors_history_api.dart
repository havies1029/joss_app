import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/polis_endors_history/polis_endors_history_model.dart';

class PolisEndorsHistoryApi {
  Future<List<PolisEndorsHistoryModel>> getPolisEndorsHistory({
    required PolisEndorsHistoryCob cob,
    required String polis2Id,
    String searchText = '',
    int hal = 0,
  }) async {
    final cleanPolis2Id = polis2Id.trim();
    if (cleanPolis2Id.isEmpty) {
      throw ArgumentError.value(polis2Id, 'polis2Id', 'wajib diisi');
    }
    if (hal < 0) {
      throw ArgumentError.value(hal, 'hal', 'tidak boleh kurang dari 0');
    }

    final endpoint =
        '${AppData.prefixEndPoint}/api/polisendorshistory/${cob.name}/getlist';
    final queryParams = _queryParams(
      cob: cob,
      polis2Id: cleanPolis2Id,
      searchText: searchText,
      hal: hal,
    );
    final uri = AppData.uriHtpp(
      AppData.httpAuthority,
      endpoint,
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat riwayat endorsement (${response.statusCode}).',
      );
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded is! List) {
      throw const FormatException(
        'Respons riwayat endorsement bukan berupa daftar.',
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => PolisEndorsHistoryModel.fromJson(
            json,
            cob: cob,
          ),
        )
        .toList();
  }

  Map<String, String> _queryParams({
    required PolisEndorsHistoryCob cob,
    required String polis2Id,
    required String searchText,
    required int hal,
  }) {
    final params = <String, String>{
      switch (cob) {
        PolisEndorsHistoryCob.mv => 'polis2mvId',
        PolisEndorsHistoryCob.par => 'polis2parId',
        PolisEndorsHistoryCob.hull => 'polis2hullId',
        PolisEndorsHistoryCob.health => 'polis2healthId',
        PolisEndorsHistoryCob.others => 'polis2othersId',
      }: polis2Id,
    };

    if (cob.supportsPagination) {
      params['searchText'] = searchText.trim();
      params['hal'] = hal.toString();
    }

    return params;
  }
}
