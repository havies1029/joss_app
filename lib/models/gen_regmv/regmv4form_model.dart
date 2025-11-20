class Regmv4FormModel {
	String caption;
	String regmv4Id;
	String? stnkStreamId;

	Regmv4FormModel({required this.caption, required this.regmv4Id, this.stnkStreamId});

	factory Regmv4FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv4FormModel(
			caption: data['caption'] ?? '',
			regmv4Id: data['regmv4Id'] ?? '',
			stnkStreamId: data['stnkStreamId'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'caption': caption,
		'regmv4Id': regmv4Id,
		'stnkStreamId': stnkStreamId,
	};
}
