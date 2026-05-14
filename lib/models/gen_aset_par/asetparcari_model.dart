class AsetParCariModel {
	String asetParId;
	String tertanggung;
	DateTime periodeMulai;
	DateTime periodeAkhir;
	String curr;
	String polisNo;
	double premi;
	double sumInsured;
	int nomor;
	String status;
	String filePolisParId;
	String filePolisEqId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;
	String satuan;

	AsetParCariModel({
		required this.asetParId,
		required this.tertanggung,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.nomor,
		required this.polisNo,
		required this.premi,
		required this.status,
		required this.sumInsured,
		required this.filePolisParId,
		required this.filePolisEqId,
		required this.prosesId,
		required this.prosesRemarks,
		required this.prosesSource,
		required this.jmlObject,
		required this.satuan,
		this.isReaktif = false,
		this.isRenewal = false,
	});

	factory AsetParCariModel.fromJson(Map<String, dynamic> data) {
		return AsetParCariModel(
			asetParId: data['asetParId'] ?? '',
			tertanggung: data['tertanggung'] ?? '',
			periodeMulai:
			DateTime.tryParse(data['periodeMulai'] ?? '') ??
					DateTime(1970),
			periodeAkhir:
			DateTime.tryParse(data['periodeAkhir'] ?? '') ??
					DateTime(1970),
			curr: data['curr'] ?? '',
			nomor: int.tryParse(data['nomor'].toString()) ?? 0,
			polisNo: data['polisNo'] ?? '',
			premi: double.tryParse(data['premi'].toString()) ?? 0,
			status: data['status'] ?? '',
			sumInsured:
			double.tryParse(data['sumInsured'].toString()) ?? 0,
			filePolisParId: data['filePolisParId'] ?? '',
			filePolisEqId: data['filePolisEqId'] ?? '',
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
		'asetParId': asetParId,
		'tertanggung': tertanggung,
		'periodeMulai': periodeMulai.toIso8601String(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'curr': curr,
		'nomor': nomor,
		'polisNo': polisNo,
		'premi': premi,
		'status': status,
		'sumInsured': sumInsured,
		'filePolisParId': filePolisParId,
		'filePolisEqId': filePolisEqId,
		'prosesId': prosesId,
		'prosesRemarks': prosesRemarks,
		'prosesSource': prosesSource,
		'isReaktif': isReaktif,
		'isRenewal': isRenewal,
		'jmlObject': jmlObject,
		'satuan': satuan,
	};
}