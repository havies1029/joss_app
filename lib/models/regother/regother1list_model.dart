
class Regother1ListModel {
	String currId;
	String mcobId;
	String regother1Id;
	String remark;
	double tsi;
	String cobNama;
	String rMATAUANGNAMA;

	Regother1ListModel({required this.currId, required this.mcobId, 
		required this.regother1Id, required this.remark, 
		required this.tsi, required this.cobNama, 
		required this.rMATAUANGNAMA});

	factory Regother1ListModel.fromJson(Map<String, dynamic> data) {
		return Regother1ListModel(
			currId: data['currId']??'',
			mcobId: data['mcobId']??'',
			regother1Id: data['regother1Id']??'',
			remark: data['remark']??'',
			tsi: double.tryParse(data['tsi'].toString())??0,
			cobNama: data['cobNama']??'',
			rMATAUANGNAMA: data['rMATAUANGNAMA']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'currId': currId,
		'mcobId': mcobId,
		'regother1Id': regother1Id,
		'remark': remark,
		'tsi': tsi.toString(),
		'cobNama': cobNama,
		'rMATAUANGNAMA': rMATAUANGNAMA};

}
