
class Sppa2othersCariModel {
	String info1;
	String info2;
	String info3;
	double premiNet;
	String sppa2othersId;
	double tsi;
  String curr;

	Sppa2othersCariModel({
		required this.info1, required this.info2, 
		required this.info3, required this.premiNet, 
		required this.curr, 
		required this.sppa2othersId, required this.tsi});

	factory Sppa2othersCariModel.fromJson(Map<String, dynamic> data) {
		return Sppa2othersCariModel(
			info1: data['info1']??'',
			info2: data['info2']??'',
			info3: data['info3']??'',
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			curr: data['curr']??'',
			sppa2othersId: data['sppa2othersId']??'',
			tsi: double.tryParse(data['tsi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'info1': info1,
		'info2': info2,
		'info3': info3,
		'premiNet': premiNet.toString(),
		'curr': curr,
		'sppa2othersId': sppa2othersId,
		'tsi': tsi.toString()};
    }
