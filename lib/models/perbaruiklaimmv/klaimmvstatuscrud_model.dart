
class KlaimmvstatuscrudModel {
	bool isPilih;
	String klaim1Id;
	String statusNama;

	KlaimmvstatuscrudModel({required this.isPilih, required this.klaim1Id, 
		required this.statusNama});

	factory KlaimmvstatuscrudModel.fromJson(Map<String, dynamic> data) {
		return KlaimmvstatuscrudModel(
			isPilih: data['isPilih']??'',
			klaim1Id: data['klaim1Id']??'',
			statusNama: data['statusNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'isPilih': isPilih,
		'klaim1Id': klaim1Id,
		'statusNama': statusNama};

}
