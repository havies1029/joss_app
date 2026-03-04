
class DnsppamvFormModel {
	String coverNama;
	String currDesc;
	double dnOs;
	String dn1Id;
	String insuredNama;
	DateTime jthTempo;
	String merkNama;
	String modelNama;
	String mvgroupNama;
	String noPolis;
	String penggunaanDesc;
	DateTime polisAkhir;
	DateTime polisMulai;
	String sppa1Id;
	String stsBayar;
	int thnBuat;
	String tipeNama;
	String wilayahNama;

	DnsppamvFormModel({required this.coverNama, required this.currDesc, 
		required this.dnOs, required this.dn1Id, 
		required this.insuredNama, required this.jthTempo, 
		required this.merkNama, required this.modelNama, 
		required this.mvgroupNama, required this.noPolis, 
		required this.penggunaanDesc, required this.polisAkhir, 
		required this.polisMulai, required this.sppa1Id, 
		required this.stsBayar, required this.thnBuat, 
		required this.tipeNama, required this.wilayahNama});

	factory DnsppamvFormModel.fromJson(Map<String, dynamic> data) {
		return DnsppamvFormModel(
			coverNama: data['coverNama']??'',
			currDesc: data['currDesc']??'',
			dnOs: double.tryParse(data['dnOs'].toString())??0,
			dn1Id: data['dn1Id']??'',
			insuredNama: data['insuredNama']??'',
			jthTempo: DateTime.tryParse(data['jthTempo'].toString())??DateTime.now(),
			merkNama: data['merkNama']??'',
			modelNama: data['modelNama']??'',
			mvgroupNama: data['mvgroupNama']??'',
			noPolis: data['noPolis']??'',
			penggunaanDesc: data['penggunaanDesc']??'',
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
			sppa1Id: data['sppa1Id']??'',
			stsBayar: data['stsBayar']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			tipeNama: data['tipeNama']??'',
			wilayahNama: data['wilayahNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'coverNama': coverNama,
		'currDesc': currDesc,
		'dnOs': dnOs.toString(),
		'dn1Id': dn1Id,
		'insuredNama': insuredNama,
		'jthTempo': jthTempo.toIso8601String(),
		'merkNama': merkNama,
		'modelNama': modelNama,
		'mvgroupNama': mvgroupNama,
		'noPolis': noPolis,
		'penggunaanDesc': penggunaanDesc,
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
		'sppa1Id': sppa1Id,
		'stsBayar': stsBayar,
		'thnBuat': thnBuat.toString(),
		'tipeNama': tipeNama,
		'wilayahNama': wilayahNama};

}
