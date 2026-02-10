
class MstatusrinciCariModel {
	String groupNama;
	String mgroupstatusclaimId;
	int noUrut;

	MstatusrinciCariModel({required this.groupNama, required this.mgroupstatusclaimId, 
		required this.noUrut});

	factory MstatusrinciCariModel.fromJson(Map<String, dynamic> data) {
		return MstatusrinciCariModel(
			groupNama: data['groupNama']??'',
			mgroupstatusclaimId: data['mgroupstatusclaimId']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'groupNama': groupNama,
		'mgroupstatusclaimId': mgroupstatusclaimId,
		'noUrut': noUrut.toString()};

}
