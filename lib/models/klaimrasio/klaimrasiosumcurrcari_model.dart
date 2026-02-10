
class KlaimrasiosumcurrCariModel {
	String curr;
	double klaimAmount;
	double premiAmount;
	double rasio;
	String cobId;

	KlaimrasiosumcurrCariModel({required this.curr, required this.klaimAmount, 
		required this.premiAmount, required this.rasio, 
		required this.cobId});

	factory KlaimrasiosumcurrCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimrasiosumcurrCariModel(
			curr: data['curr']??'',
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			premiAmount: double.tryParse(data['premiAmount'].toString())??0,
			rasio: double.tryParse(data['rasio'].toString())??0,
			cobId: data['cobId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'curr': curr,
		'klaimAmount': klaimAmount.toString(),
		'premiAmount': premiAmount.toString(),
		'rasio': rasio.toString(),
		'cobId': cobId};

}
