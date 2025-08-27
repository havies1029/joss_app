class MRekan1CrudModel {
  String mrekan1Id;
  String rekanNama;
  String telepon;
  String email;
  int polisCount;
  double polisAmount;
  String mjnsclientId;
  bool isSetujuTC;

  MRekan1CrudModel(
      {required this.mrekan1Id,
      required this.rekanNama,
      this.telepon = '',
      this.email = '',
      required this.polisCount,
      required this.polisAmount,
      required this.mjnsclientId,
      required this.isSetujuTC});

  factory MRekan1CrudModel.fromJson(Map<String, dynamic> data) {
    return MRekan1CrudModel(
      mrekan1Id: data['mrekan1Id'] ?? '',
      rekanNama: data['rekanNama'] ?? '',
      telepon: data['telepon'] ?? '',
      email: data['email'] ?? '',
      polisCount: int.tryParse(data['polisCount'].toString()) ?? 0,
      polisAmount: double.tryParse(data['polisAmount'].toString()) ?? 0,
      mjnsclientId: data['mjnsclientId'] ?? '',
      isSetujuTC: data['isSetujuTC'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'mrekan1Id': mrekan1Id,
        'rekanNama': rekanNama,
        'telepon': telepon,
        'email': email,
        'polisCount': polisCount.toString(),
        'polisAmount': polisAmount.toString(),
        'mjnsclientId': mjnsclientId,
        'isSetujuTC': isSetujuTC
      };
}
