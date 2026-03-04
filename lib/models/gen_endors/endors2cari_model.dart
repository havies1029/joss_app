
class Endors2CariModel {
	String endors1Id;
	String endors2Id;
	String statusEndors;
	DateTime statusTgl;

	Endors2CariModel({required this.endors1Id, required this.endors2Id, 
		required this.statusEndors, required this.statusTgl});

	factory Endors2CariModel.fromJson(Map<String, dynamic> data) {
		return Endors2CariModel(
			endors1Id: data['endors1Id']??'',
			endors2Id: data['endors2Id']??'',
			statusEndors: data['statusEndors']??'',
			statusTgl: DateTime.tryParse(data['statusTgl'].toString())??DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
		{'endors1Id': endors1Id,
		'endors2Id': endors2Id,
		'statusEndors': statusEndors,
		'statusTgl': statusTgl.toIso8601String()};

}
