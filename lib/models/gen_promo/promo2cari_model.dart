
class Promo2CariModel {
	String fitur;
	int noUrut;
	String promo1Id;
	String promo2Id;

	Promo2CariModel({required this.fitur, required this.noUrut, 
		required this.promo1Id, required this.promo2Id});

	factory Promo2CariModel.fromJson(Map<String, dynamic> data) {
		return Promo2CariModel(
			fitur: data['fitur']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0,
			promo1Id: data['promo1Id']??'',
			promo2Id: data['promo2Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'fitur': fitur,
		'noUrut': noUrut.toString(),
		'promo1Id': promo1Id,
		'promo2Id': promo2Id};

}
