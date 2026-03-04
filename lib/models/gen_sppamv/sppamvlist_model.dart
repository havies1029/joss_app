
class SppamvListModel {
	double harga;
	String insuredNama;
	String mesinNo;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	String polisiNo;
	double premiTotal;
	String rangkaNo;
	String curr;
	DateTime sppaTgl;
	String sppa1Id;
	int thnBuat;
	String coverName;
	String grupNama;
	String nmMerk;
	String nmTipe;
	String warnaDesc;
	String wilayahNama;
	String ePolisId;

	SppamvListModel({	required this.harga, required this.insuredNama,
		required this.mesinNo, required this.periodeAkhir,
		required this.periodeMulai, required this.polisiNo,
		required this.premiTotal, required this.rangkaNo,
		required this.curr, required this.sppaTgl,
		required this.sppa1Id, required this.thnBuat,
		required this.coverName, required this.grupNama,
		required this.nmMerk, required this.nmTipe,
		required this.warnaDesc, required this.wilayahNama,
		this.ePolisId = ''});

	factory SppamvListModel.fromJson(Map<String, dynamic> data) {
		return SppamvListModel(
				harga: double.tryParse(data['harga'].toString())??0,
				insuredNama: data['insuredNama']??'',
				mesinNo: data['mesinNo']??'',
				periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
				periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
				polisiNo: data['polisiNo']??'',
				premiTotal: double.tryParse(data['premiTotal'].toString())??0,
				rangkaNo: data['rangkaNo']??'',
				sppaTgl: DateTime.tryParse(data['sppaTgl'].toString())??DateTime.now(),
				sppa1Id: data['sppa1Id']??'',
				thnBuat: int.tryParse(data['thnBuat'].toString())??0,
				coverName: data['coverName']??'',
				grupNama: data['grupNama']??'',
				nmMerk: data['nmMerk']??'',
				nmTipe: data['nmTipe']??'',
				curr: data['curr']??'',
				warnaDesc: data['warnaDesc']??'',
				wilayahNama: data['wilayahNama']??'',
				ePolisId: data['ePolisId']??''
		);

	}

	Map<String, dynamic> toJson() => {
		'harga': harga.toString(),
		'insuredNama': insuredNama,
		'mesinNo': mesinNo,
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'polisiNo': polisiNo,
		'premiTotal': premiTotal.toString(),
		'rangkaNo': rangkaNo,
		'sppaTgl': sppaTgl.toIso8601String(),
		'sppa1Id': sppa1Id,
		'thnBuat': thnBuat.toString(),
		'coverName': coverName,
		'grupNama': grupNama,
		'nmMerk': nmMerk,
		'nmTipe': nmTipe,
		'rMATAUANGNAMA': curr,
		'warnaDesc': warnaDesc,
		'wilayahNama': wilayahNama,
		'ePolisId': ePolisId
	};
}