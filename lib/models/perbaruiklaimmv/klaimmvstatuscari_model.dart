
class KlaimmvstatuscariModel {
	bool isPilih;
	String klaim1Id;
	String statusNama;

	KlaimmvstatuscariModel({required this.isPilih, required this.klaim1Id, 
		required this.statusNama});

	factory KlaimmvstatuscariModel.fromJson(Map<String, dynamic> data) {
		return KlaimmvstatuscariModel(
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
