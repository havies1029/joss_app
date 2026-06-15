class SppapoliscariModel {
	String polisNo;
	String sppaId;
	String sppaNoRef;

	String cobNama;
	String objectDesc;

	SppapoliscariModel({
		required this.polisNo,
		required this.sppaId,
		required this.sppaNoRef,
		required this.cobNama,
		required this.objectDesc,
	});

	factory SppapoliscariModel.fromJson(Map<String, dynamic> data) {
		return SppapoliscariModel(
			polisNo: data['polisNo'] ?? '',
			sppaId: data['sppaId'] ?? '',
			sppaNoRef: data['sppaNoRef'] ?? '',
			cobNama: data['cobNama'] ?? '',
			objectDesc: data['objectDesc'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'polisNo': polisNo,
		'sppaId': sppaId,
		'sppaNoRef': sppaNoRef,
		'cobNama': cobNama,
		'objectDesc': objectDesc,
	};
}