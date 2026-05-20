
class MlogoclientCariModel {
	bool isActive;
	String linkUrl;
	String logoNama;
	String logoSvg;
	String mlogoclientId;
	int noUrut;

	MlogoclientCariModel({required this.isActive, required this.linkUrl, 
		required this.logoNama, required this.logoSvg, 
		required this.mlogoclientId, required this.noUrut});

	factory MlogoclientCariModel.fromJson(Map<String, dynamic> data) {
		return MlogoclientCariModel(
			isActive: data['isActive']??'',
			linkUrl: data['linkUrl']??'',
			logoNama: data['logoNama']??'',
			logoSvg: data['logoSvg']??'',
			mlogoclientId: data['mlogoclientId']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'isActive': isActive,
		'linkUrl': linkUrl,
		'logoNama': logoNama,
		'logoSvg': logoSvg,
		'mlogoclientId': mlogoclientId,
		'noUrut': noUrut.toString()};

}
