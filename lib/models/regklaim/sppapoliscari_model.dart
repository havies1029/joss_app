class SppapoliscariModel {
	String polisNo;
	String sppaId;
	String sppaNoRef;

	SppapoliscariModel({
		required this.polisNo,
		required this.sppaId,
		required this.sppaNoRef,
	});

	factory SppapoliscariModel.fromJson(Map<String, dynamic> data) {
		return SppapoliscariModel(
			polisNo: data['polisNo'] ?? '',
			sppaId: data['sppaId'] ?? '',
			sppaNoRef: data['sppaNoRef'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'polisNo': polisNo,
		'sppaId': sppaId,
		'sppaNoRef': sppaNoRef,
	};
}