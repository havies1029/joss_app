
class Regmv6FormModel {
	double diskonPersen;
	double premiAdd;
	double premiAw;
	double premiCasco;
	double premiDiskon;
	double premiEq;
	double premiFlood;
	double premiNet;
	double premiPad;
	double premiPap;
	double premiPll;
	double premiSrcc;
	double premiSubtotal;
	double premiTbod;
	double premiTerrorism;
	double premiTjh;
	String regmv6Id;

	Regmv6FormModel({required this.diskonPersen, required this.premiAdd, 
		required this.premiAw, required this.premiCasco, 
		required this.premiDiskon, required this.premiEq, 
		required this.premiFlood, required this.premiNet, 
		required this.premiPad, required this.premiPap, 
		required this.premiPll, required this.premiSrcc, 
		required this.premiSubtotal, required this.premiTbod, 
		required this.premiTerrorism, required this.premiTjh, 
		required this.regmv6Id});

	factory Regmv6FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv6FormModel(
			diskonPersen: double.tryParse(data['diskonPersen'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiAw: double.tryParse(data['premiAw'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiDiskon: double.tryParse(data['premiDiskon'].toString())??0,
			premiEq: double.tryParse(data['premiEq'].toString())??0,
			premiFlood: double.tryParse(data['premiFlood'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiPad: double.tryParse(data['premiPad'].toString())??0,
			premiPap: double.tryParse(data['premiPap'].toString())??0,
			premiPll: double.tryParse(data['premiPll'].toString())??0,
			premiSrcc: double.tryParse(data['premiSrcc'].toString())??0,
			premiSubtotal: double.tryParse(data['premiSubtotal'].toString())??0,
			premiTbod: double.tryParse(data['premiTbod'].toString())??0,
			premiTerrorism: double.tryParse(data['premiTerrorism'].toString())??0,
			premiTjh: double.tryParse(data['premiTjh'].toString())??0,
			regmv6Id: data['regmv6Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'diskonPersen': diskonPersen.toString(),
		'premiAdd': premiAdd.toString(),
		'premiAw': premiAw.toString(),
		'premiCasco': premiCasco.toString(),
		'premiDiskon': premiDiskon.toString(),
		'premiEq': premiEq.toString(),
		'premiFlood': premiFlood.toString(),
		'premiNet': premiNet.toString(),
		'premiPad': premiPad.toString(),
		'premiPap': premiPap.toString(),
		'premiPll': premiPll.toString(),
		'premiSrcc': premiSrcc.toString(),
		'premiSubtotal': premiSubtotal.toString(),
		'premiTbod': premiTbod.toString(),
		'premiTerrorism': premiTerrorism.toString(),
		'premiTjh': premiTjh.toString(),
		'regmv6Id': regmv6Id};

}
