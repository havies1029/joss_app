
class MlogoclientCariModel {
  String mlogoclientId;
  String logoNama;
  String logoSvg;
  String linkUrl;
  int noUrut;
  bool isActive;

  MlogoclientCariModel({
    required this.mlogoclientId,
    required this.logoNama,
    required this.logoSvg,
    required this.linkUrl,
    required this.noUrut,
    required this.isActive,
  });

  factory MlogoclientCariModel.fromJson(
      Map<String, dynamic> data,
      ) {
    return MlogoclientCariModel(
      mlogoclientId: data['mlogoclientId'] ?? '',
      logoNama: data['logoNama'] ?? '',
      logoSvg: data['logoSvg'] ?? '',
      linkUrl: data['linkUrl'] ?? '',
      noUrut: data['noUrut'] ?? 0,
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'mlogoclientId': mlogoclientId,
    'logoNama': logoNama,
    'logoSvg': logoSvg,
    'linkUrl': linkUrl,
    'noUrut': noUrut,
    'isActive': isActive,
  };
}