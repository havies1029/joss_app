class AsetothersCariModel {
	String asetOthersId;
	String tertanggung;
	DateTime? periodeMulai;
	DateTime? periodeAkhir;
	String curr;
	int nomor;
	String polisNo;
	double premi;
	String status;
	double sumInsured;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;
	String satuan;

	AsetothersCariModel({
		required this.asetOthersId,
		required this.tertanggung,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.nomor,
		required this.polisNo,
		required this.premi,
		required this.status,
		required this.sumInsured,
		required this.filePolisId,
		required this.prosesId,
		required this.prosesRemarks,
		required this.prosesSource,
		required this.jmlObject,
		required this.satuan,
		this.isReaktif = false,
		this.isRenewal = false,
	});

	factory AsetothersCariModel.fromJson(Map<String, dynamic> data) {
		return AsetothersCariModel(
			asetOthersId: data['asetOthersId'] ?? '',
			tertanggung: data['tertanggung'] ?? '',
			periodeMulai: data['periodeMulai'] == null
					? null
					: DateTime.tryParse(data['periodeMulai'].toString()),
			periodeAkhir: data['periodeAkhir'] == null
					? null
					: DateTime.tryParse(data['periodeAkhir'].toString()),
			curr: data['curr'] ?? '',
			nomor: int.tryParse(data['nomor'].toString()) ?? 0,
			polisNo: data['polisNo'] ?? '',
			premi: double.tryParse(data['premi'].toString()) ?? 0,
			status: data['status'] ?? '',
			sumInsured: double.tryParse(data['sumInsured'].toString()) ?? 0,
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
		'asetOthersId': asetOthersId,
		'tertanggung': tertanggung,
		'periodeMulai': periodeMulai?.toIso8601String(),
		'periodeAkhir': periodeAkhir?.toIso8601String(),
		'curr': curr,
		'nomor': nomor,
		'polisNo': polisNo,
		'premi': premi,
		'status': status,
		'sumInsured': sumInsured,
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