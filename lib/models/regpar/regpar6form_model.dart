
class Regpar6FormModel {
	String fotoCaption;
	String regpar6Id;

	Regpar6FormModel({required this.fotoCaption, 
		required this.regpar6Id});

	factory Regpar6FormModel.fromJson(Map<String, dynamic> data) {
		return Regpar6FormModel(
			fotoCaption: data['fotoCaption']??'',
			regpar6Id: data['regpar6Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fotoCaption': fotoCaption,
		'regpar6Id': regpar6Id};

}
