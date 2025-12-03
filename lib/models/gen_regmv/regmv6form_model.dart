
class Regmv6FormModel {
	double diskonPersen;
	double premiAdd;
	double premiCasco;
	double premiDiskon;
	double premiNet;
	double premiSubtotal;
	String regmv6Id;

	Regmv6FormModel({required this.diskonPersen, required this.premiAdd,
		required this.premiCasco, required this.premiDiskon,
		required this.premiNet, required this.premiSubtotal,
		required this.regmv6Id});

	factory Regmv6FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv6FormModel(
				diskonPersen: double.tryParse(data['diskonPersen'].toString())??0,
				premiAdd: double.tryParse(data['premiAdd'].toString())??0,
				premiCasco: double.tryParse(data['premiCasco'].toString())??0,
				premiDiskon: double.tryParse(data['premiDiskon'].toString())??0,
				premiNet: double.tryParse(data['premiNet'].toString())??0,
				premiSubtotal: double.tryParse(data['premiSubtotal'].toString())??0,
				regmv6Id: data['regmv6Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
			{'diskonPersen': diskonPersen.toString(),
				'premiAdd': premiAdd.toString(),
				'premiCasco': premiCasco.toString(),
				'premiDiskon': premiDiskon.toString(),
				'premiNet': premiNet.toString(),
				'premiSubtotal': premiSubtotal.toString(),
				'regmv6Id': regmv6Id};

}
