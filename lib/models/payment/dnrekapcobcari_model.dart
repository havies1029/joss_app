
class DnrekapcobCariModel {
	String cobId;
	String cobNama;
	String currId;
	String currSimbol;
	String dnrekapcobId;
	double polisAmount;
	int polisCount;
  double tsi;

	DnrekapcobCariModel({required this.cobId, required this.cobNama, 
		required this.currId, required this.currSimbol, 
		required this.dnrekapcobId, required this.polisAmount, 
		required this.polisCount, required this.tsi});

	factory DnrekapcobCariModel.fromJson(Map<String, dynamic> data) {
		return DnrekapcobCariModel(
			cobId: data['cobId']??'',
			cobNama: data['cobNama']??'',
			currId: data['currId']??'',
			currSimbol: data['currSimbol']??'',
			dnrekapcobId: data['dnrekapcobId']??'',
			polisAmount: double.tryParse(data['polisAmount'].toString())??0,
			polisCount: int.tryParse(data['polisCount'].toString())??0,
      tsi: double.tryParse(data['tsi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobId': cobId,
		'cobNama': cobNama,
		'currId': currId,
		'currSimbol': currSimbol,
		'dnrekapcobId': dnrekapcobId,
		'polisAmount': polisAmount.toString(),
		'polisCount': polisCount.toString(),
    'tsi': tsi.toString()};

}
