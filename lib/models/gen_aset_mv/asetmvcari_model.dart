
class AsetMvCariModel {
	String asetMvId;
  String sppa2Id;
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
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;

	AsetMvCariModel({required this.asetMvId, 
    required this.sppa2Id,
    required this.tertanggung,
		required this.periodeMulai, required this.periodeAkhir,
		required this.curr,
		required this.jenisMv, required this.merk,
		required this.noPolisi, required this.nomor,
		required this.polisNo, required this.premi,
		required this.sumInsured, required this.tahun,
		required this.modelMv, required this.status, required this.filePolisId,
		required this.prosesId, required this.prosesRemarks, required this.prosesSource,
		this.isReaktif = false, this.isRenewal = false});

	factory AsetMvCariModel.fromJson(Map<String, dynamic> data) {
		return AsetMvCariModel(
				asetMvId: data['asetMvId']??'',
        sppa2Id: data['sppa2Id']??'',
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
				prosesId: data['prosesId']??'',
				prosesRemarks: data['prosesRemarks']??'',
				prosesSource: data['prosesSource']??'',
				isReaktif: data['isReaktif']??false,
				isRenewal: data['isRenewal']??false
		);

	}

	Map<String, dynamic> toJson() =>
			{'asetMvId': asetMvId,
        'sppa2Id': sppa2Id,
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
				'prosesId': prosesId,
				'prosesRemarks': prosesRemarks,
				'prosesSource': prosesSource,
				'isReaktif': isReaktif,
				'isRenewal': isRenewal
			};

}
