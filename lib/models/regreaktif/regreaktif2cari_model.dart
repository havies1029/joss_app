
class Regreaktif2CariModel {
	String progressNama;
	String regreaktif2Id;
	String remarks;
	DateTime tglStatus;

	Regreaktif2CariModel({required this.progressNama, required this.regreaktif2Id, 
		required this.remarks, required this.tglStatus});

	factory Regreaktif2CariModel.fromJson(Map<String, dynamic> data) {
		return Regreaktif2CariModel(
			progressNama: data['progressNama']??'',
			regreaktif2Id: data['regreaktif2Id']??'',
			remarks: data['remarks']??'',
			tglStatus: DateTime.tryParse(data['tglStatus'].toString())??DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
		{'progressNama': progressNama,
		'regreaktif2Id': regreaktif2Id,
		'remarks': remarks,
		'tglStatus': tglStatus.toIso8601String()};

}
