
class Sppa2parCariModel {
	String lokasi1;
	String lokasi2;
	double premiNet;
	String sppa2parId;
	double tsiTotal;
	String okupasiDesc;
  String curr;

	Sppa2parCariModel({required this.lokasi1, required this.lokasi2, 
		required this.premiNet, required this.sppa2parId, 
		required this.tsiTotal, required this.okupasiDesc, 
		required this.curr});


	factory Sppa2parCariModel.fromJson(Map<String, dynamic> data) {
		return Sppa2parCariModel(
			lokasi1: data['lokasi1']??'',
			lokasi2: data['lokasi2']??'',
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			sppa2parId: data['sppa2parId']??'',
			tsiTotal: double.tryParse(data['tsiTotal'].toString())??0,
			okupasiDesc: data['okupasiDesc']??'',
			curr: data['curr']??'');
  }

	Map<String, dynamic> toJson() =>
		{'lokasi1': lokasi1,
		'lokasi2': lokasi2,
		'premiNet': premiNet.toString(),
		'sppa2parId': sppa2parId,
		'tsiTotal': tsiTotal.toString(),
		'okupasiDesc': okupasiDesc,
		'curr': curr};
}
