class AsetHealthCariModel {
	String asethealthId;
	int nomor;
	String status;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;
	int jmlObject;
	String polisNo;

	AsetHealthCariModel({
		required this.asethealthId,
		required this.nomor,
		required this.status,
		required this.filePolisId,
		required this.prosesId,
		required this.prosesRemarks,
		required this.prosesSource,
		required this.jmlObject,
		required this.polisNo,
		this.isReaktif = false,
		this.isRenewal = false,
	});

	factory AsetHealthCariModel.fromJson(Map<String, dynamic> data) {
		return AsetHealthCariModel(
			asethealthId: data['asethealthId'] ?? '',
			nomor: int.tryParse(data['nomor'].toString()) ?? 0,
			status: data['status'] ?? '',
			filePolisId: data['filePolisId'] ?? '',
			prosesId: data['prosesId'] ?? '',
			prosesRemarks: data['prosesRemarks'] ?? '',
			prosesSource: data['prosesSource'] ?? '',
			isReaktif: data['isReaktif'] ?? false,
			isRenewal: data['isRenewal'] ?? false,
			jmlObject: int.tryParse(data['jmlObject'].toString()) ?? 0,
			polisNo: data['polisNo'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'asethealthId': asethealthId,
		'nomor': nomor,
		'status': status,
		'filePolisId': filePolisId,
		'prosesId': prosesId,
		'prosesRemarks': prosesRemarks,
		'prosesSource': prosesSource,
		'isReaktif': isReaktif,
		'isRenewal': isRenewal,
		'jmlObject': jmlObject,
		'polisNo': polisNo,
	};
}