
class Sppa2mvCariModel {
	double harga;
	String mesinNo;
	String polisiNo;
	double premiNet;
	String rangkaNo;
	String sppa2mvId;
	int thnBuat;
	String coverName;
  String curr;
  String merk;
  String jenisMv;
  String modelMv;

	Sppa2mvCariModel({
		required this.harga, required this.mesinNo, 
		required this.polisiNo, required this.premiNet, 
		required this.rangkaNo, required this.sppa2mvId, 
		required this.thnBuat, required this.coverName, 
		required this.curr, required this.merk, 
		required this.jenisMv, required this.modelMv});

	factory Sppa2mvCariModel.fromJson(Map<String, dynamic> data) {
		return Sppa2mvCariModel(
			harga: double.tryParse(data['harga'].toString())??0,
			mesinNo: data['mesinNo']??'',
			polisiNo: data['polisiNo']??'',
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			rangkaNo: data['rangkaNo']??'',
			sppa2mvId: data['sppa2mvId']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			coverName: data['coverName']??'',
			curr: data['curr']??'',
			merk: data['merk']??'',
			jenisMv: data['jenisMv']??'',
			modelMv: data['modelMv']??''
		);
	}

	Map<String, dynamic> toJson() =>
		{'harga': harga.toString(),
		'mesinNo': mesinNo,
		'polisiNo': polisiNo,
		'premiNet': premiNet.toString(),
		'rangkaNo': rangkaNo,
		'sppa2mvId': sppa2mvId,
		'thnBuat': thnBuat.toString(),
		'coverName': coverName,
		'curr': curr,
		'merk': merk,
		'jenisMv': jenisMv,
		'modelMv': modelMv};

}
