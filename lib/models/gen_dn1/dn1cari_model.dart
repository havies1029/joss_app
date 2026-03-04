
class Dn1CariModel {
	String curr;
	double dnNilai;
	String dn1Id;
	DateTime jthTempo;
	String stsLunas;
	String sppa1Id;

	Dn1CariModel({required this.curr, required this.dnNilai, 
		required this.dn1Id, required this.jthTempo, 
		required this.stsLunas, 
		required this.sppa1Id});

	factory Dn1CariModel.fromJson(Map<String, dynamic> data) {
		return Dn1CariModel(
			curr: data['curr']??'',
			dnNilai: double.tryParse(data['dnNilai'].toString())??0,
			dn1Id: data['dn1Id']??'',
			jthTempo: DateTime.tryParse(data['jthTempo'].toString())??DateTime.now(),
			stsLunas: data['stsLunas']??'',
			sppa1Id: data['sppa1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'curr': curr,
		'dnNilai': dnNilai.toString(),
		'dn1Id': dn1Id,
		'jthTempo': jthTempo.toIso8601String(),
		'stsLunas': stsLunas,
		'sppa1Id': sppa1Id};

}
