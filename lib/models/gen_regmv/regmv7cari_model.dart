
class Regmv7CariModel {
	String accNama;
	String regmv7Id;

	Regmv7CariModel({required this.accNama, required this.regmv7Id});

	factory Regmv7CariModel.fromJson(Map<String, dynamic> data) {
		return Regmv7CariModel(
			accNama: data['accNama']??'',
			regmv7Id: data['regmv7Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'accNama': accNama,
		'regmv7Id': regmv7Id};

}
