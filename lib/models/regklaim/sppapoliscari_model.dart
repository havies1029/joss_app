
class SppapoliscariModel {
	String polisNo;
	String sppaId;

	SppapoliscariModel({required this.polisNo, required this.sppaId});

	factory SppapoliscariModel.fromJson(Map<String, dynamic> data) {
		return SppapoliscariModel(
			polisNo: data['polisNo']??'',
			sppaId: data['sppaId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'polisNo': polisNo,
		'sppaId': sppaId};

}
