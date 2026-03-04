
class StatusAsetCariModel {
	String mstatusasetId;
	int noUrut;
	String statusNama;

	StatusAsetCariModel({required this.mstatusasetId, required this.noUrut, 
		required this.statusNama});

	factory StatusAsetCariModel.fromJson(Map<String, dynamic> data) {
		return StatusAsetCariModel(
			mstatusasetId: data['mstatusasetId']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0,
			statusNama: data['statusNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'mstatusasetId': mstatusasetId,
		'noUrut': noUrut.toString(),
		'statusNama': statusNama};

}
