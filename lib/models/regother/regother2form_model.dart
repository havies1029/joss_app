
class Regother2FormModel {
	String fotoCaption;
	String regother2Id;

	Regother2FormModel({required this.fotoCaption, 
		required this.regother2Id});

	factory Regother2FormModel.fromJson(Map<String, dynamic> data) {
		return Regother2FormModel(
			fotoCaption: data['fotoCaption']??'',
			regother2Id: data['regother2Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fotoCaption': fotoCaption,
		'regother2Id': regother2Id};

}
