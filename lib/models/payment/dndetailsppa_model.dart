
class DnDetailSppaModel {
	String cobId;
	String currSimbol;
	double dnOs;
	String dn1Id;
	String noPolis;
	String objectDesc;
	DateTime polisAkhir;
	DateTime polisMulai;
  int rownumber;
	String sppa1Id;

	DnDetailSppaModel({required this.cobId, required this.currSimbol,
		required this.dnOs, required this.dn1Id,
		required this.noPolis, required this.objectDesc,
		required this.polisAkhir, required this.polisMulai,
		required this.rownumber,
		required this.sppa1Id});

	factory DnDetailSppaModel.fromJson(Map<String, dynamic> data) {
		return DnDetailSppaModel(
			cobId: data['cobId']??'',
			currSimbol: data['currSimbol']??'',
			dnOs: double.tryParse(data['dnOs'].toString())??0,
			dn1Id: data['dn1Id']??'',
			noPolis: data['noPolis']??'',
			objectDesc: data['objectDesc']??'',
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
      rownumber: data['rownumber']??0,
			sppa1Id: data['sppa1Id']??''
		);

	}
	Map<String, dynamic> toExportMap() {
		return {
			'No Polis': noPolis,
			'Periode Mulai': polisAkhir.toIso8601String(),
			'Periode Akhir': polisMulai.toIso8601String(),
			'Currency': currSimbol,
			'Premi': dnOs.toString(),
		};
	}

	Map<String, dynamic> toJson() =>
		{'cobId': cobId,
		'currSimbol': currSimbol,
		'dnOs': dnOs.toString(),
		'dn1Id': dn1Id,
		'noPolis': noPolis,
		'objectDesc': objectDesc,
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
    'rownumber': rownumber,
		'sppa1Id': sppa1Id};

}
