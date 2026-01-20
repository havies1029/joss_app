
class AsethullCariModel {
	String asetHullId;
	String tertanggung;
	DateTime periodeMulai;
	DateTime periodeAkhir;
	String curr;
	String namaKapal;
	String polisNo;
	double premi;
	String status;
	double tsi;
	int nomor;
	String filePolisId;

	AsethullCariModel({required this.asetHullId,
		required this.tertanggung,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.namaKapal, required this.polisNo,
		required this.premi, required this.status,
		required this.tsi, required this.nomor, required this.filePolisId});

	factory AsethullCariModel.fromJson(Map<String, dynamic> data) {
		return AsethullCariModel(
			asetHullId: data['asetHullId']??'',
			tertanggung: data['tertanggung']??'',
			periodeMulai: DateTime.tryParse(data['periodeMulai']??'') ?? DateTime(1970),
			periodeAkhir: DateTime.tryParse(data['periodeAkhir']??'') ?? DateTime(1970),
			curr: data['curr']??'',
			namaKapal: data['namaKapal']??'',
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			status: data['status']??'',
			tsi: double.tryParse(data['tsi'].toString())??0,
			nomor: int.tryParse(data['nomor'].toString())??0,
			filePolisId: data['filePolisId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
			{'asetHullId': asetHullId,
				'tertanggung': tertanggung,
				'periodeMulai': periodeMulai.toIso8601String(),
				'periodeAkhir': periodeAkhir.toIso8601String(),
				'curr': curr,
				'namaKapal': namaKapal,
				'polisNo': polisNo,
				'premi': premi,
				'tsi': tsi,
				'status': status,
				'nomor': nomor,
				'filePolisId': filePolisId,
			};

}
