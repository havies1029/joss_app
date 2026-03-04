
class Pay1ListModel {
	DateTime arTgl;
	String ar1Id;
	int sppaCount;
	double totalOs;

	Pay1ListModel({required this.arTgl, required this.ar1Id, 
		required this.sppaCount, required this.totalOs});

	factory Pay1ListModel.fromJson(Map<String, dynamic> data) {
		return Pay1ListModel(
			arTgl: DateTime.tryParse(data['arTgl'].toString())??DateTime.now(),
			ar1Id: data['ar1Id']??'',
			sppaCount: int.tryParse(data['sppaCount'].toString())??0,
			totalOs: double.tryParse(data['totalOs'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'arTgl': arTgl.toIso8601String(),
		'ar1Id': ar1Id,
		'sppaCount': sppaCount.toString(),
		'totalOs': totalOs.toString()};

}
