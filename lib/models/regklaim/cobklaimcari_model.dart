
class CobklaimcariModel {
	String cobIcon;
	String cobNama;
	bool isAktif;
	String mcobklaim1Id;
	int noUrut;

	CobklaimcariModel({required this.cobIcon, required this.cobNama, 
		required this.isAktif, required this.mcobklaim1Id, 
		required this.noUrut});

	factory CobklaimcariModel.fromJson(Map<String, dynamic> data) {
		return CobklaimcariModel(
			cobIcon: data['cobIcon']??'',
			cobNama: data['cobNama']??'',
			isAktif: data['isAktif']??'',
			mcobklaim1Id: data['mcobklaim1Id']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobIcon': cobIcon,
		'cobNama': cobNama,
		'isAktif': isAktif,
		'mcobklaim1Id': mcobklaim1Id,
		'noUrut': noUrut.toString()};

}
