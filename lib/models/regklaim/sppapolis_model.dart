
class SppaPolisModel {
	String polisNo;
	String sppaId;

	SppaPolisModel({required this.polisNo, required this.sppaId});

	factory SppaPolisModel.fromJson(Map<String, dynamic> data) {
		return SppaPolisModel(
			polisNo: data['polisNo']??'',
			sppaId: data['sppaId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'polisNo': polisNo,
		'sppaId': sppaId};

}
