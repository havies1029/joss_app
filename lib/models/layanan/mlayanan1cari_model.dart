class Mlayanan1CariModel {
  String mLayanan1Id;
  String titleText;
  String descText;
  List<Mlayanan2CariModel> mLayanan2;

  Mlayanan1CariModel({
    required this.mLayanan1Id,
    required this.titleText,
    required this.descText,
    required this.mLayanan2,
  });

  factory Mlayanan1CariModel.fromJson(Map<String, dynamic> data) {
    return Mlayanan1CariModel(
      mLayanan1Id: data['mLayanan1Id'] ?? '',
      titleText: data['titleText'] ?? '',
      descText: data['descText'] ?? '',
      mLayanan2: data['mLayanan2'] != null
          ? List<Mlayanan2CariModel>.from(
              data['mLayanan2'].map(
                (item) => Mlayanan2CariModel.fromJson(item),
              ),
            )
          : <Mlayanan2CariModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'mLayanan1Id': mLayanan1Id,
        'titleText': titleText,
        'descText': descText,
        'mLayanan2': mLayanan2.map((item) => item.toJson()).toList(),
      };
}

class Mlayanan2CariModel {
  String mLayanan2Id;
  String mLayanan1Id;
  String jenisLayanan;
  String namaLayanan;
  String descLayanan;
  String logoLayanan;
  String noTelepon;
  String email;
  String linkLayanan;
  int urutan;

  Mlayanan2CariModel({
    required this.mLayanan2Id,
    required this.mLayanan1Id,
    required this.jenisLayanan,
    required this.namaLayanan,
    required this.descLayanan,
    required this.logoLayanan,
    required this.noTelepon,
    required this.email,
    required this.linkLayanan,
    required this.urutan,
  });

  factory Mlayanan2CariModel.fromJson(Map<String, dynamic> data) {
    return Mlayanan2CariModel(
      mLayanan2Id: data['mLayanan2Id'] ?? '',
      mLayanan1Id: data['mLayanan1Id'] ?? '',
      jenisLayanan: data['jenisLayanan'] ?? '',
      namaLayanan: data['namaLayanan'] ?? '',
      descLayanan: data['descLayanan'] ?? '',
      logoLayanan: data['logoLayanan'] ?? '',
      noTelepon: data['noTelepon'] ?? '',
      email: data['email'] ?? '',
      linkLayanan: data['linkLayanan'] ?? '',
      urutan: data['urutan'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'mLayanan2Id': mLayanan2Id,
        'mLayanan1Id': mLayanan1Id,
        'jenisLayanan': jenisLayanan,
        'namaLayanan': namaLayanan,
        'descLayanan': descLayanan,
        'logoLayanan': logoLayanan,
        'noTelepon': noTelepon,
        'email': email,
        'linkLayanan': linkLayanan,
        'urutan': urutan,
      };
}