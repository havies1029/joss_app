
class Regpar1ListModel {
	String regpar1Id;
	String ttgAlamat;
	String ttgNama;

	Regpar1ListModel({required this.regpar1Id, required this.ttgAlamat, 
		required this.ttgNama});

	factory Regpar1ListModel.fromJson(Map<String, dynamic> data) {
		return Regpar1ListModel(
			regpar1Id: data['regpar1Id']??'',
			ttgAlamat: data['ttgAlamat']??'',
			ttgNama: data['ttgNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'regpar1Id': regpar1Id,
		'ttgAlamat': ttgAlamat,
		'ttgNama': ttgNama};

}
