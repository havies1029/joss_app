class AsetMvCariModel {
	String asetMvId;
	String tertanggung;
	DateTime periodeMulai;
	DateTime periodeAkhir;
	String curr;
	String polisNo;
	double premi;
	double sumInsured;
	String status;
	int nomor;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;

	AsetMvCariModel({
		required this.asetMvId,
		required this.tertanggung,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.polisNo,
		required this.premi,
		required this.sumInsured,
		required this.status,
		required this.nomor,
		required this.filePolisId,
		required this.prosesId,
		required this.prosesRemarks,
		required this.prosesSource,
		required this.jmlObject,
		this.isReaktif = false,
		this.isRenewal = false,
	});

	factory AsetMvCariModel.fromJson(Map<String, dynamic> data) {
		return AsetMvCariModel(
			asetMvId: data['asetMvId'] ?? '',
			tertanggung: data['tertanggung'] ?? '',
			periodeMulai:
			DateTime.tryParse(data['periodeMulai'] ?? '') ??
					DateTime(1970),
			periodeAkhir:
			DateTime.tryParse(data['periodeAkhir'] ?? '') ??
					DateTime(1970),
			curr: data['curr'] ?? '',
			polisNo: data['polisNo'] ?? '',
			premi: double.tryParse(data['premi'].toString()) ?? 0,
			sumInsured: double.tryParse(data['sumInsured'].toString()) ?? 0,
			status: data['status'] ?? '',
			nomor: int.tryParse(data['nomor'].toString()) ?? 0,
			filePolisId: data['filePolisId'] ?? '',
			prosesId: data['prosesId'] ?? '',
			prosesRemarks: data['prosesRemarks'] ?? '',
			prosesSource: data['prosesSource'] ?? '',
			isReaktif: data['isReaktif'] ?? false,
			isRenewal: data['isRenewal'] ?? false,
			jmlObject: int.tryParse(data['jmlObject'].toString()) ?? 0,
		);
	}

	Map<String, dynamic> toJson() => {
		'asetMvId': asetMvId,
		'tertanggung': tertanggung,
		'periodeMulai': periodeMulai.toIso8601String(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'curr': curr,
		'polisNo': polisNo,
		'premi': premi,
		'sumInsured': sumInsured,
		'status': status,
		'nomor': nomor,
		'filePolisId': filePolisId,
		'prosesId': prosesId,
		'prosesRemarks': prosesRemarks,
		'prosesSource': prosesSource,
		'isReaktif': isReaktif,
		'isRenewal': isRenewal,
		'jmlObject': jmlObject,
	};
}