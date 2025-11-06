
class Calmv3FormModel {
	String calmv3Id;
	String calmv1Id;
	double diskonPersen;
	double premiAdd;
	double premiCasco;
	double premiDiskon;
	double premiNet;
	double premiSubtotal;

	Calmv3FormModel({required this.calmv3Id, required this.calmv1Id,required this.diskonPersen,
		required this.premiAdd, required this.premiCasco, 
		required this.premiDiskon, required this.premiNet, 
		required this.premiSubtotal});

	factory Calmv3FormModel.fromJson(Map<String, dynamic> data) {
		return Calmv3FormModel(
			calmv3Id: data['calmv3Id']??'',
				calmv1Id: data['calmv1Id'] ?? '',
			diskonPersen: double.tryParse(data['diskonPersen'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiDiskon: double.tryParse(data['premiDiskon'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiSubtotal: double.tryParse(data['premiSubtotal'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'calmv3Id': calmv3Id,'calmv1Id': calmv1Id,
		'diskonPersen': diskonPersen.toString(),
		'premiAdd': premiAdd.toString(),
		'premiCasco': premiCasco.toString(),
		'premiDiskon': premiDiskon.toString(),
		'premiNet': premiNet.toString(),
		'premiSubtotal': premiSubtotal.toString()};

}
