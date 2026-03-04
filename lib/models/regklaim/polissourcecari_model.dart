
class PolissourcecariModel {
	String polissourceId;
	String sourceNama;

	PolissourcecariModel({required this.polissourceId, required this.sourceNama});

	factory PolissourcecariModel.fromJson(Map<String, dynamic> data) {
		return PolissourcecariModel(
			polissourceId: data['polissourceId']??'',
			sourceNama: data['sourceNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'polissourceId': polissourceId,
		'sourceNama': sourceNama};

}
