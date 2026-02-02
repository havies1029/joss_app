
class Historybayar2CariModel {
	String curr;
	String dn1Id;
	double nilaiBayar;
	String polisNo;
	String sppa1Id;

	Historybayar2CariModel({required this.curr, required this.dn1Id, 
		required this.nilaiBayar, required this.polisNo, 
		required this.sppa1Id});

	factory Historybayar2CariModel.fromJson(Map<String, dynamic> data) {
		return Historybayar2CariModel(
			curr: data['curr']??'',
			dn1Id: data['dn1Id']??'',
			nilaiBayar: double.tryParse(data['nilaiBayar'].toString())??0,
			polisNo: data['polisNo']??'',
			sppa1Id: data['sppa1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'curr': curr,
		'dn1Id': dn1Id,
		'nilaiBayar': nilaiBayar.toString(),
		'polisNo': polisNo,
		'sppa1Id': sppa1Id};

}
