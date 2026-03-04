
class KlaimrasiograndcurrCariModel {
	String curr;
	double klaimAmount;
	double premiAmount;
	double rasio;

	KlaimrasiograndcurrCariModel({required this.curr, required this.klaimAmount, 
		required this.premiAmount, required this.rasio});

	factory KlaimrasiograndcurrCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimrasiograndcurrCariModel(
			curr: data['curr']??'',
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			premiAmount: double.tryParse(data['premiAmount'].toString())??0,
			rasio: double.tryParse(data['rasio'].toString())??0,
		);

	}

	Map<String, dynamic> toJson() =>
		{'curr': curr,
		'klaimAmount': klaimAmount.toString(),
		'premiAmount': premiAmount.toString(),
		'rasio': rasio.toString()};

}
