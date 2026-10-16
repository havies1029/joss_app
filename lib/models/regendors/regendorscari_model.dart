class RegendorsCariModel {
  DateTime endorsTgl;
  String minsuranceId;
  String mrekanId;
  String mstsendorsId;
  String notePerubahan;
  String regendors1Id;
  String polis1Id;

  // Alias transisi untuk consumer respons lama.
  String get sppa1Id => polis1Id;
  String insuranceName;

  RegendorsCariModel(
      {required this.endorsTgl,
      required this.minsuranceId,
      required this.mrekanId,
      required this.mstsendorsId,
      required this.notePerubahan,
      required this.regendors1Id,
      required this.polis1Id,
      required this.insuranceName});

  factory RegendorsCariModel.fromJson(Map<String, dynamic> data) {
    return RegendorsCariModel(
        endorsTgl:
            DateTime.tryParse(data['endorsTgl'].toString()) ?? DateTime.now(),
        minsuranceId: data['minsuranceId'] ?? '',
        mrekanId: data['mrekanId'] ?? '',
        mstsendorsId: data['mstsendorsId'] ?? '',
        notePerubahan: data['notePerubahan'] ?? '',
        regendors1Id: data['regendors1Id'] ?? '',
        polis1Id: (data['polis1Id'] ?? data['sppa1Id'] ?? '').toString(),
        insuranceName: data['insuranceName'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'endorsTgl': endorsTgl.toIso8601String(),
        'minsuranceId': minsuranceId,
        'mrekanId': mrekanId,
        'mstsendorsId': mstsendorsId,
        'notePerubahan': notePerubahan,
        'regendors1Id': regendors1Id,
        'polis1Id': polis1Id,
        'insuranceName': insuranceName
      };
}
