
class DnGrandTotalModel {
	String currSimbol;
	double totalOs;

	DnGrandTotalModel({required this.currSimbol, required this.totalOs});

	factory DnGrandTotalModel.fromJson(Map<String, dynamic> data) {
		return DnGrandTotalModel(
			currSimbol: data['currSimbol']??'',
			totalOs: double.tryParse(data['totalOs'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'currSimbol': currSimbol,
		'totalOs': totalOs.toString()};

}
