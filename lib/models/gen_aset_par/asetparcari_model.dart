
class AsetParCariModel {
	String alamat;
	String asetParId;
	String curr;
	String klausulaBank;
	String mrekanId;
	int nomor;
	String polisNo;
	double premi;
	String status;
	double sumInsured;

	AsetParCariModel({required this.alamat, required this.asetParId, 
		required this.curr, 
		required this.klausulaBank, required this.mrekanId, 
		required this.nomor, 
		required this.polisNo, required this.premi, 
		required this.status, required this.sumInsured});

	factory AsetParCariModel.fromJson(Map<String, dynamic> data) {
		return AsetParCariModel(
			alamat: data['alamat']??'',
			asetParId: data['asetParId']??'',
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
		{'alamat': alamat,
		'asetParId': asetParId,
		'curr': curr,
		'klausulaBank': klausulaBank,
		'mrekanId': mrekanId,
		'nomor': nomor,
		'polisNo': polisNo,
		'premi': premi,
		'status': status,
		'sumInsured': sumInsured};

}
