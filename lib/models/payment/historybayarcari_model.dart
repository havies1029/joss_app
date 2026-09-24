class HistorybayarCariModel {
  DateTime invTgl;
  String inv1Id;
  int jmlPolis;
  String polisNo;
  int nomor;
  String status;
  double totalBayar;
  String curr;
  String stsInvId;
  bool isActive;

  HistorybayarCariModel({
    required this.invTgl,
    required this.inv1Id,
    required this.jmlPolis,
    required this.polisNo,
    required this.nomor,
    required this.status,
    required this.totalBayar,
    required this.curr,
    required this.stsInvId,
    required this.isActive,
  });

  factory HistorybayarCariModel.fromJson(Map<String, dynamic> data) {
    return HistorybayarCariModel(
      invTgl: DateTime.tryParse(data['invTgl'].toString()) ?? DateTime.now(),
      inv1Id: data['inv1Id'] ?? '',
      jmlPolis: int.tryParse(data['jmlPolis'].toString()) ?? 0,
      polisNo: data['polisNo'] ?? '',
      nomor: int.tryParse(data['nomor'].toString()) ?? 0,
      status: data['status'] ?? '',
      totalBayar: double.tryParse(data['totalBayar'].toString()) ?? 0,
      curr: data['curr'] ?? '',
      stsInvId: data['stsInvId'] ?? '',
      isActive: _readBool(data['isActive']),
    );
  }

  Map<String, dynamic> toJson() => {
        'invTgl': invTgl.toIso8601String(),
        'inv1Id': inv1Id,
        'jmlPolis': jmlPolis.toString(),
        'polisNo': polisNo,
        'nomor': nomor.toString(),
        'status': status,
        'totalBayar': totalBayar.toString(),
        'curr': curr,
        'stsInvId': stsInvId,
        'isActive': isActive,
      };

  static bool _readBool(dynamic value) {
    if (value == true) return true;
    if (value == false || value == null) return false;

    final normalized = value.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}
