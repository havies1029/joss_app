
class AsethullCariModel {
	String asetHullId;
	String curr;
	String namaKapal;
	String polisNo;
	double premi;
	String status;
	double tsi;

	AsethullCariModel({required this.asetHullId, required this.curr, 
		required this.namaKapal, required this.polisNo, 
		required this.premi, required this.status, 
		required this.tsi});

	factory AsethullCariModel.fromJson(Map<String, dynamic> data) {
		return AsethullCariModel(
			asetHullId: data['asetHullId']??'',
			curr: data['curr']??'',
			namaKapal: data['namaKapal']??'',
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			status: data['status']??'',
			tsi: double.tryParse(data['tsi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'asetHullId': asetHullId,
		'curr': curr,
		'namaKapal': namaKapal,
		'polisNo': polisNo,
		'premi': premi.toString(),
		'status': status,
		'tsi': tsi.toString()};

}
