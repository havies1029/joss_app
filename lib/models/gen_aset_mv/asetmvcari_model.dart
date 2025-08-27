
class AsetMvCariModel {
	String asetMvId;
	String curr;
	String jenisMv;
	String merk;
	String noPolisi;
	int nomor;
	String polisNo;
	double premi;
	double sumInsured;
	int tahun;
	String tipe;
	String status;


	AsetMvCariModel({required this.asetMvId, required this.curr, 
		required this.jenisMv, required this.merk, 
		required this.noPolisi, required this.nomor, 
		required this.polisNo, required this.premi, 
		required this.sumInsured, required this.tahun, 
		required this.tipe, required this.status});

	factory AsetMvCariModel.fromJson(Map<String, dynamic> data) {
		return AsetMvCariModel(
			asetMvId: data['asetMvId']??'',
			curr: data['curr']??'',
			jenisMv: data['jenisMv']??'',
			merk: data['merk']??'',
			noPolisi: data['noPolisi']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			sumInsured: double.tryParse(data['sumInsured'].toString())??0,
			tahun: int.tryParse(data['tahun'].toString())??0,
			tipe: data['tipe']??'',
				status: data['status']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'asetMvId': asetMvId,
		'curr': curr,
		'jenisMv': jenisMv,
		'merk': merk,
		'noPolisi': noPolisi,
		'nomor': nomor.toString(),
		'polisNo': polisNo,
		'premi': premi.toString(),
		'sumInsured': sumInsured.toString(),
		'tahun': tahun.toString(),
		'tipe': tipe,
			'status': status};

}
