
class Sppa2hullCariModel {
	String kerangka;
	String namaKapal;
	double premiNet;
	double si;
	String sppa2hullId;
	String vesselClass;
	String curr;

	Sppa2hullCariModel({
    required this.kerangka, required this.namaKapal,      
		required this.premiNet, required this.si, 
		required this.sppa2hullId, 
		required this.vesselClass, required this.curr});

	factory Sppa2hullCariModel.fromJson(Map<String, dynamic> data) {
		return Sppa2hullCariModel(			
			kerangka: data['kerangka']??'',
			namaKapal: data['namaKapal']??'',
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			si: double.tryParse(data['si'].toString())??0,
			sppa2hullId: data['sppa2hullId']??'',
			vesselClass: data['vesselClass']??'',
			curr: data['curr']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'kerangka': kerangka,
		'namaKapal': namaKapal,
		'premiNet': premiNet.toString(),
		'si': si.toString(),
		'sppa2hullId': sppa2hullId,
		'vesselClass': vesselClass,
    'curr': curr,
      };

}
