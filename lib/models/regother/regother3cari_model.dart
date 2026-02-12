
class Regother3cariModel {
	String regother3Id;
	String remarks;
	DateTime tglStatus;
  String progressNama;

	Regother3cariModel({required this.regother3Id, required this.remarks, 
		required this.tglStatus, required this.progressNama});

	factory Regother3cariModel.fromJson(Map<String, dynamic> data) {
		return Regother3cariModel(
			regother3Id: data['regother3Id']??'',
			remarks: data['remarks']??'',
			tglStatus: DateTime.tryParse(data['tglStatus'].toString())??DateTime.now(), 
      progressNama: data['progressNama']??'',
		);

	}

	Map<String, dynamic> toJson() =>
    {'regother3Id': regother3Id,
		'remarks': remarks,
		'tglStatus': tglStatus.toIso8601String(),
    'progressNama': progressNama,
    };

}
