
class Regmv4CariModel {
	String caption;
	String regmv4Id;

	Regmv4CariModel({required this.caption, required this.regmv4Id});
	factory Regmv4CariModel.fromJson(Map<String, dynamic> data) {
		return Regmv4CariModel(
			caption: data['caption']??'',
			regmv4Id: data['regmv4Id']??''
		);
	}

	Map<String, dynamic> toJson() =>
		{'caption': caption,
		'regmv4Id': regmv4Id};

}
