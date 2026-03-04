
class Regpar6CariModel {
	String fotoCaption;
	String regpar1Id;
	String regpar6Id;

	Regpar6CariModel({required this.fotoCaption, 
		required this.regpar1Id, required this.regpar6Id});

	factory Regpar6CariModel.fromJson(Map<String, dynamic> data) {
		return Regpar6CariModel(
			fotoCaption: data['fotoCaption']??'',
			regpar1Id: data['regpar1Id']??'',
			regpar6Id: data['regpar6Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fotoCaption': fotoCaption,
		'regpar1Id': regpar1Id,
		'regpar6Id': regpar6Id};

}
