
class AsetMvCariModel {
	String asetMvId;
	String tertanggung;
	DateTime periodeMulai;
	DateTime periodeAkhir;
	String curr;
	String merk;
	String jenisMv;
	String noPolisi;
	String polisNo;
	double premi;
	double sumInsured;
	int tahun;
	String modelMv;
	int nomor;
	String status;
	String filePolisId;

	AsetMvCariModel({required this.asetMvId, required this.tertanggung,
		required this.periodeMulai, required this.periodeAkhir,
		required this.curr,
		required this.jenisMv, required this.merk,
		required this.noPolisi, required this.nomor,
		required this.polisNo, required this.premi,
		required this.sumInsured, required this.tahun,
		required this.modelMv, required this.status, required this.filePolisId});

	factory AsetMvCariModel.fromJson(Map<String, dynamic> data) {
		return AsetMvCariModel(
			asetMvId: data['asetMvId']??'',
			tertanggung: data['tertanggung']??'',
			periodeMulai: DateTime.tryParse(data['periodeMulai']??'') ?? DateTime(1970),
			periodeAkhir: DateTime.tryParse(data['periodeAkhir']??'') ?? DateTime(1970),
			curr: data['curr']??'',
			jenisMv: data['jenisMv']??'',
			merk: data['merk']??'',
			noPolisi: data['noPolisi']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			sumInsured: double.tryParse(data['sumInsured'].toString())??0,
			tahun: int.tryParse(data['tahun'].toString())??0,
			modelMv: data['modelMv']??'',
			status: data['status']??'',
			filePolisId: data['filePolisId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
			{'asetMvId': asetMvId,
				'tertanggung': tertanggung,
				'periodeMulai': periodeMulai.toIso8601String(),
				'periodeAkhir': periodeAkhir.toIso8601String(),
				'curr': curr,
				'jenisMv': jenisMv,
				'merk': merk,
				'noPolisi': noPolisi,
				'nomor': nomor.toString(),
				'polisNo': polisNo,
				'premi': premi.toString(),
				'sumInsured': sumInsured.toString(),
				'tahun': tahun.toString(),
				'modelMv': modelMv,
				'status': status,
				'filePolisId': filePolisId,
			};

}
