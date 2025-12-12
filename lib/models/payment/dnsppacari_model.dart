
class DnsppaCariModel {
	String currSimbol;
	double dnOs;
	String dn1Id;
	String noPolis;
	String objectDesc;
	DateTime polisAkhir;
	DateTime polisMulai;
	String sppa1Id;

	DnsppaCariModel({required this.currSimbol, required this.dnOs, 
		required this.dn1Id, required this.noPolis, 
		required this.objectDesc, required this.polisAkhir, 
		required this.polisMulai, required this.sppa1Id});

	factory DnsppaCariModel.fromJson(Map<String, dynamic> data) {
		return DnsppaCariModel(
			currSimbol: data['currSimbol']??'',
			dnOs: double.tryParse(data['dnOs'].toString())??0,
			dn1Id: data['dn1Id']??'',
			noPolis: data['noPolis']??'',
			objectDesc: data['objectDesc']??'',
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
			sppa1Id: data['sppa1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'currSimbol': currSimbol,
		'dnOs': dnOs.toString(),
		'dn1Id': dn1Id,
		'noPolis': noPolis,
		'objectDesc': objectDesc,
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
		'sppa1Id': sppa1Id};

}
