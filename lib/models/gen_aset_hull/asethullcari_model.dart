class AsethullCariModel {
	String asetHullId;
	String tertanggung;
	DateTime? periodeMulai;
	DateTime? periodeAkhir;
	String curr;
	String polisNo;
	double premi;
	String status;
	double tsi;
	int nomor;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;
	String satuan;

	AsethullCariModel({
		required this.asetHullId,
		required this.tertanggung,
		this.periodeMulai,
		this.periodeAkhir,
		required this.curr,
		required this.polisNo,
		required this.premi,
		required this.status,
		required this.tsi,
		required this.nomor,
		required this.filePolisId,
		required this.prosesId,
		required this.prosesRemarks,
		required this.prosesSource,
		required this.jmlObject,
		required this.satuan,
		this.isReaktif = false,
		this.isRenewal = false,
	});

	factory AsethullCariModel.fromJson(Map<String, dynamic> data) {
		return AsethullCariModel(
			asetHullId: data['asetHullId'] ?? '',
			tertanggung: data['tertanggung'] ?? '',
			periodeMulai: data['periodeMulai'] == null
					? null
					: DateTime.tryParse(data['periodeMulai'].toString()),
			periodeAkhir: data['periodeAkhir'] == null
					? null
					: DateTime.tryParse(data['periodeAkhir'].toString()),
			curr: data['curr'] ?? '',
			polisNo: data['polisNo'] ?? '',
			premi: double.tryParse(data['premi'].toString()) ?? 0,
			status: data['status'] ?? '',
			tsi: double.tryParse(data['tsi'].toString()) ?? 0,
			nomor: int.tryParse(data['nomor'].toString()) ?? 0,
			filePolisId: data['filePolisId'] ?? '',
			prosesId: data['prosesId'] ?? '',
			prosesRemarks: data['prosesRemarks'] ?? '',
			prosesSource: data['prosesSource'] ?? '',
			isReaktif: data['isReaktif'] ?? false,
			isRenewal: data['isRenewal'] ?? false,
			jmlObject: int.tryParse(data['jmlObject'].toString()) ?? 0,
			satuan: data['satuan'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'asetHullId': asetHullId,
		'tertanggung': tertanggung,
		'periodeMulai': periodeMulai?.toIso8601String(),
		'periodeAkhir': periodeAkhir?.toIso8601String(),
		'curr': curr,
		'polisNo': polisNo,
		'premi': premi,
		'tsi': tsi,
		'status': status,
		'nomor': nomor,
		'filePolisId': filePolisId,
		'prosesId': prosesId,
		'prosesRemarks': prosesRemarks,
		'prosesSource': prosesSource,
		'isReaktif': isReaktif,
		'isRenewal': isRenewal,
		'jmlObject': jmlObject,
		'satuan': satuan,
	};
}