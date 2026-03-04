
class Regmv7FormModel {
	String accNama;
	String regmv7Id;

	Regmv7FormModel({required this.accNama, 
		required this.regmv7Id});

	factory Regmv7FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv7FormModel(
			accNama: data['accNama']??'',
			regmv7Id: data['regmv7Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'accNama': accNama,
		'regmv7Id': regmv7Id};

}
