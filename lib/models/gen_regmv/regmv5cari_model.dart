
class Regmv5CariModel {
	String fotoCaption;
	String regmv5Id;

	Regmv5CariModel({required this.fotoCaption, required this.regmv5Id});
	factory Regmv5CariModel.fromJson(Map<String, dynamic> data) {
		return Regmv5CariModel(
			fotoCaption: data['fotoCaption']??'',
			regmv5Id: data['regmv5Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fotoCaption': fotoCaption,
		'regmv5Id': regmv5Id};

}
