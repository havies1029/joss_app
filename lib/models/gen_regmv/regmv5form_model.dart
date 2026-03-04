
class Regmv5FormModel {
	String fotoCaption;
	String regmv5Id;

	Regmv5FormModel({required this.fotoCaption, required this.regmv5Id});

	factory Regmv5FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv5FormModel(
			fotoCaption: data['fotoCaption']??'',
			regmv5Id: data['regmv5Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fotoCaption': fotoCaption,
		'regmv5Id': regmv5Id};

}
