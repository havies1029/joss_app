
class KlaimbatalcrudModel {
	String alasanBatal;
	String klaim1Id;

	KlaimbatalcrudModel({required this.alasanBatal, required this.klaim1Id});

	factory KlaimbatalcrudModel.fromJson(Map<String, dynamic> data) {
		return KlaimbatalcrudModel(
			alasanBatal: data['alasanBatal']??'',
			klaim1Id: data['klaim1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'alasanBatal': alasanBatal,
		'klaim1Id': klaim1Id};

}
