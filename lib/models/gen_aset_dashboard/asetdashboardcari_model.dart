
class AsetDashboardCariModel {
	int aktifQty;
	int berakhirQty;
	int nonAktifQty;
	int onProgressQty;

	AsetDashboardCariModel({required this.aktifQty, required this.berakhirQty, 
		required this.nonAktifQty, required this.onProgressQty});

	factory AsetDashboardCariModel.fromJson(Map<String, dynamic> data) {
		return AsetDashboardCariModel(
			aktifQty: int.tryParse(data['aktifQty'].toString())??0,
			berakhirQty: int.tryParse(data['berakhirQty'].toString())??0,
			nonAktifQty: int.tryParse(data['nonAktifQty'].toString())??0,
			onProgressQty: int.tryParse(data['onProgressQty'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'aktifQty': aktifQty.toString(),
		'berakhirQty': berakhirQty.toString(),
		'nonAktifQty': nonAktifQty.toString(),
		'onProgressQty': onProgressQty.toString()};

}
