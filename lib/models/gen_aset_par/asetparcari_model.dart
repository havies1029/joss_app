
class AsetParCariModel {
	String asetParId;
	String tertanggung;
	String alamat;
	String periodeMulai;
	String periodeAkhir;
	String periode;
	String curr;
	String klausulaBank;
	String mrekanId;
	int nomor;
	String polisNo;
	double premi;
	String status;
	double sumInsured;

	AsetParCariModel({
		required this.asetParId,
		required this.tertanggung,
		required this.alamat,
		required this.periodeMulai,
		required this.periodeAkhir,
		required this.periode,
		required this.curr, 
		required this.klausulaBank, required this.mrekanId, 
		required this.nomor, 
		required this.polisNo, required this.premi, 
		required this.status, required this.sumInsured});

	factory AsetParCariModel.fromJson(Map<String, dynamic> data) {
		return AsetParCariModel(
			asetParId: data['asetParId']??'',
			tertanggung: data['tertanggung']??'',
			alamat: data['alamat']??'',
			periodeMulai: data['periodeMulai']??'',
			periodeAkhir: data['periodeAkhir']??'',
			periode: data['periode']??'',
			curr: data['curr']??'',
			klausulaBank: data['klausulaBank']??'',
			mrekanId: data['mrekanId']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			status: data['status']??'',
			sumInsured: double.tryParse(data['sumInsured'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'asetParId': asetParId,
		'tertanggung': tertanggung,
		'alamat': alamat,
		'periodeMulai' : periodeMulai,
		'periodeAkhir' : periodeAkhir,
		'periode' : periode,
		'curr': curr,
		'klausulaBank': klausulaBank,
		'mrekanId': mrekanId,
		'nomor': nomor,
		'polisNo': polisNo,
		'premi': premi,
		'status': status,
		'sumInsured': sumInsured};

}
