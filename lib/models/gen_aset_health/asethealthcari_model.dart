class AsetHealthCariModel {
	String asethealthId;
	String tertanggung;
	DateTime? periodeMulai;
	DateTime? periodeAkhir;
	String curr;
	double premi;
	double sumInsured;
	String polisNo;
	String status;
	int nomor;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;
	String satuan;

	AsetHealthCariModel({
		required this.asethealthId,
		required this.tertanggung,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.premi,
		required this.sumInsured,
		required this.polisNo,
		required this.status,
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

	factory AsetHealthCariModel.fromJson(Map<String, dynamic> data) {
		return AsetHealthCariModel(
			asethealthId: data['asethealthId'] ?? '',
			tertanggung: data['tertanggung'] ?? '',
			periodeMulai: data['periodeMulai'] == null
					? null
					: DateTime.tryParse(data['periodeMulai'].toString()),
			periodeAkhir: data['periodeAkhir'] == null
					? null
					: DateTime.tryParse(data['periodeAkhir'].toString()),
			curr: data['curr'] ?? '',
			premi: double.tryParse(data['premi'].toString()) ?? 0,
			sumInsured: double.tryParse(data['sumInsured'].toString()) ?? 0,
			polisNo: data['polisNo'] ?? '',
			status: data['status'] ?? '',
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
		'asethealthId': asethealthId,
		'tertanggung': tertanggung,
		'periodeMulai': periodeMulai?.toIso8601String(),
		'periodeAkhir': periodeAkhir?.toIso8601String(),
		'curr': curr,
		'premi': premi,
		'sumInsured': sumInsured,
		'polisNo': polisNo,
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