
class Regmv1CrudModel {
	String calmv1Id;
	String regmv1Id;
	String ttgAlamat;
	String ttgNama;

	Regmv1CrudModel({required this.calmv1Id, required this.regmv1Id, 
		required this.ttgAlamat, required this.ttgNama});

	factory Regmv1CrudModel.fromJson(Map<String, dynamic> data) {
		return Regmv1CrudModel(
			calmv1Id: data['calmv1Id']??'',
			regmv1Id: data['regmv1Id']??'',
			ttgAlamat: data['ttgAlamat']??'',
			ttgNama: data['ttgNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'calmv1Id': calmv1Id,
		'regmv1Id': regmv1Id,
		'ttgAlamat': ttgAlamat,
		'ttgNama': ttgNama};

}
