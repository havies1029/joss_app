
class AsetParCariModel {
	String asetParId;
	String tertanggung;
	String alamat;
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

	AsetParCariModel({required this.asetParId,
		required this.tertanggung,
		required this.alamat,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.curr,
		required this.nomor,
		required this.polisNo, required this.premi,
		required this.status, required this.sumInsured,
		required this.filePolisParId, required this.filePolisEqId});

	factory AsetParCariModel.fromJson(Map<String, dynamic> data) {
		return AsetParCariModel(
			asetParId: data['asetParId']??'',
			tertanggung: data['tertanggung']??'',
			periodeMulai: DateTime.tryParse(data['periodeMulai']??'') ?? DateTime(1970),
			periodeAkhir: DateTime.tryParse(data['periodeAkhir']??'') ?? DateTime(1970),
			alamat: data['alamat']??'',
			curr: data['curr']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			status: data['status']??'',
			sumInsured: double.tryParse(data['sumInsured'].toString())??0,
			filePolisParId: data['filePolisParId']??'',
			filePolisEqId: data['filePolisEqId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
			{
				'asetParId': asetParId,
				'tertanggung': tertanggung,
				'periodeMulai': periodeMulai.toIso8601String(),
				'periodeAkhir': periodeAkhir.toIso8601String(),
				'alamat': alamat,
				'curr': curr,
				'nomor': nomor,
				'polisNo': polisNo,
				'premi': premi,
				'status': status,
				'sumInsured': sumInsured,
				'filePolisParId': filePolisParId,
				'filePolisEqId': filePolisEqId,
			};

}
