enum PolisEndorsHistoryCob {
  mv,
  par,
  hull,
  health,
  others;

  bool get supportsPagination =>
      this == PolisEndorsHistoryCob.hull ||
      this == PolisEndorsHistoryCob.health ||
      this == PolisEndorsHistoryCob.others;
}

class PolisEndorsHistoryModel {
  final PolisEndorsHistoryCob cob;

  final String endors1Id;
  final String endors2Id;
  final String polis2Id;
  final String placing2Id;
  final String endors2InfinityId;
  final String sppaEndorsNo;
  final String endorsNo;
  final DateTime? effectiveDate;
  final String noPolis;
  final double nilaiPertanggungan;
  final double tsi;
  final double premi;
  final String deskripsi;
  final String curr;
  final DateTime? endorsDate;
  final String statusPolis;
  final int rowNumber;
  final int totalRows;

  // Motor vehicle.
  final String merk;
  final String jenisMv;
  final String modelMv;
  final String coverName;
  final String polisiNo;
  final String mesinNo;
  final String rangkaNo;
  final int thnBuat;

  // Property all risks.
  final String lokasi1;
  final String lokasi2;
  final String okupasiDesc;
  final String buildingDesc;
  final String machineryDesc;
  final String contentDesc;
  final String stockDesc;
  final String otherDesc;

  // Hull.
  final String namaKapal;
  final String kelasKapal;
  final String vesselClass;
  final String kerangka;
  final String coverage;
  final String warrantyTrading;
  final String deductible;

  // Health.
  final String nama;
  final String paketNama;
  final String idNo;
  final DateTime? lahirTgl;
  final String jenisKelamin;
  final String koperasi;
  final String address;
  final String contractNo;

  // Other COB.
  final String info1;
  final String info2;
  final String info3;
  final String info;

  const PolisEndorsHistoryModel({
    required this.cob,
    required this.endors1Id,
    required this.endors2Id,
    required this.polis2Id,
    required this.placing2Id,
    required this.endors2InfinityId,
    required this.sppaEndorsNo,
    required this.endorsNo,
    required this.effectiveDate,
    required this.noPolis,
    required this.nilaiPertanggungan,
    required this.tsi,
    required this.premi,
    required this.deskripsi,
    required this.curr,
    required this.endorsDate,
    required this.statusPolis,
    required this.rowNumber,
    required this.totalRows,
    this.merk = '',
    this.jenisMv = '',
    this.modelMv = '',
    this.coverName = '',
    this.polisiNo = '',
    this.mesinNo = '',
    this.rangkaNo = '',
    this.thnBuat = 0,
    this.lokasi1 = '',
    this.lokasi2 = '',
    this.okupasiDesc = '',
    this.buildingDesc = '',
    this.machineryDesc = '',
    this.contentDesc = '',
    this.stockDesc = '',
    this.otherDesc = '',
    this.namaKapal = '',
    this.kelasKapal = '',
    this.vesselClass = '',
    this.kerangka = '',
    this.coverage = '',
    this.warrantyTrading = '',
    this.deductible = '',
    this.nama = '',
    this.paketNama = '',
    this.idNo = '',
    this.lahirTgl,
    this.jenisKelamin = '',
    this.koperasi = '',
    this.address = '',
    this.contractNo = '',
    this.info1 = '',
    this.info2 = '',
    this.info3 = '',
    this.info = '',
  });

  factory PolisEndorsHistoryModel.fromJson(
    Map<String, dynamic> data, {
    required PolisEndorsHistoryCob cob,
  }) {
    return PolisEndorsHistoryModel(
      cob: cob,
      endors1Id: _asString(data['endors1Id']),
      endors2Id: _asString(data['endors2Id']),
      polis2Id: _polis2Id(data, cob),
      placing2Id: _asString(data['placing2Id']),
      endors2InfinityId: _asString(data['endors2InfinityId']),
      sppaEndorsNo: _asString(data['sppaEndorsNo']),
      endorsNo: _asString(data['endorsNo']),
      effectiveDate: _asDate(data['effectiveDate']),
      noPolis: _asString(data['noPolis']),
      nilaiPertanggungan: _asDouble(data['nilaiPertanggungan']),
      tsi: _asDouble(data['tsi']),
      premi: _asDouble(data['premi']),
      deskripsi: _asString(data['deskripsi']),
      curr: _asString(data['curr']),
      endorsDate: _asDate(data['endorsDate']),
      statusPolis: _asString(data['statusPolis']),
      rowNumber: _asInt(data['rownumber']),
      totalRows: _asInt(data['totalrows']),
      merk: _asString(data['merk']),
      jenisMv: _asString(data['jenisMv']),
      modelMv: _asString(data['modelMv']),
      coverName: _asString(data['coverName']),
      polisiNo: _asString(data['polisiNo']),
      mesinNo: _asString(data['mesinNo']),
      rangkaNo: _asString(data['rangkaNo']),
      thnBuat: _asInt(data['thnBuat']),
      lokasi1: _asString(data['lokasi1']),
      lokasi2: _asString(data['lokasi2']),
      okupasiDesc: _asString(data['okupasiDesc']),
      buildingDesc: _asString(data['buildingDesc']),
      machineryDesc: _asString(data['machineryDesc']),
      contentDesc: _asString(data['contentDesc']),
      stockDesc: _asString(data['stockDesc']),
      otherDesc: _asString(data['otherDesc']),
      namaKapal: _asString(data['namaKapal']),
      kelasKapal: _asString(data['kelasKapal']),
      vesselClass: _asString(data['vesselClass']),
      kerangka: _asString(data['kerangka']),
      coverage: _asString(data['coverage']),
      warrantyTrading: _asString(data['warrantyTrading']),
      deductible: _asString(data['deductible']),
      nama: _asString(data['nama']),
      paketNama: _asString(data['paketNama']),
      idNo: _asString(data['idNo']),
      lahirTgl: _asDate(data['lahirTgl']),
      jenisKelamin: _asString(data['jenisKelamin']),
      koperasi: _asString(data['koperasi']),
      address: _asString(data['address']),
      contractNo: _asString(data['contractNo']),
      info1: _asString(data['info1']),
      info2: _asString(data['info2']),
      info3: _asString(data['info3']),
      info: _asString(data['info']),
    );
  }

  static String _polis2Id(
    Map<String, dynamic> data,
    PolisEndorsHistoryCob cob,
  ) {
    return switch (cob) {
      PolisEndorsHistoryCob.mv => _asString(data['polis2MvId']),
      PolisEndorsHistoryCob.par => _asString(data['polis2ParId']),
      PolisEndorsHistoryCob.hull => _asString(data['polis2HullId']),
      PolisEndorsHistoryCob.health => _asString(data['polis2HealthId']),
      PolisEndorsHistoryCob.others => _asString(data['polis2OthersId']),
    };
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    final result = value.toString().trim();
    return result.toLowerCase() == 'null' ? '' : result;
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_asString(value).replaceAll(',', '')) ?? 0;
  }

  static int _asInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(_asString(value)) ?? 0;
  }

  static DateTime? _asDate(dynamic value) {
    final text = _asString(value);
    return text.isEmpty ? null : DateTime.tryParse(text);
  }
}
