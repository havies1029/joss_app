
class Ar2CariModel {
	String ar1Id;
	String ar2Id;
	String dn1Id;
	double nilaiBayar;

	Ar2CariModel({required this.ar1Id, required this.ar2Id, 
		required this.dn1Id, required this.nilaiBayar});

	factory Ar2CariModel.fromJson(Map<String, dynamic> data) {
		return Ar2CariModel(
			ar1Id: data['ar1Id']??'',
			ar2Id: data['ar2Id']??'',
			dn1Id: data['dn1Id']??'',
			nilaiBayar: double.tryParse(data['nilaiBayar'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'ar1Id': ar1Id,
		'ar2Id': ar2Id,
		'dn1Id': dn1Id,
		'nilaiBayar': nilaiBayar.toString()};

}
