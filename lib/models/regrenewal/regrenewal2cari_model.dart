
class Regrenewal2CariModel {
	String regrenew2Id;
	String remaks;
	DateTime tglStatus;
	String progressNama;

	Regrenewal2CariModel({
		required this.regrenew2Id, required this.remaks,
		required this.tglStatus, required this.progressNama});

	factory Regrenewal2CariModel.fromJson(Map<String, dynamic> data) {
		return Regrenewal2CariModel(
				regrenew2Id: data['regrenew2Id']??'',
				remaks: data['remaks']??'',
				tglStatus: DateTime.tryParse(data['tglStatus'].toString())??DateTime.now(),
				progressNama: data['progressNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
			{
				'regrenew2Id': regrenew2Id,
				'remaks': remaks,
				'tglStatus': tglStatus.toIso8601String(),
				'progressNama': progressNama,
			};

}
