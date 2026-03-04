
class SumdashModel {
	String curr;
	int jmlpolis;
	double totalpremi;

	SumdashModel({required this.curr,
		required this.jmlpolis,
		required this.totalpremi});

	factory SumdashModel.fromJson(Map<String, dynamic> data) {
		return SumdashModel(
				curr: data['curr']??'',
				jmlpolis: int.tryParse(data['jmlpolis'].toString())??0,
				totalpremi: double.tryParse(data['totalpremi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
			{'curr': curr,
				'jmlpolis': jmlpolis.toString(),
				'totalpremi': totalpremi.toString()};

}