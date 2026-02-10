
class MstatusringkasCariModel {
	String groupNama;
	String mgroupstatusclaimId;
	int noUrut;

	MstatusringkasCariModel({required this.groupNama, required this.mgroupstatusclaimId, 
		required this.noUrut});

	factory MstatusringkasCariModel.fromJson(Map<String, dynamic> data) {
		return MstatusringkasCariModel(
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
