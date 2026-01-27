
class MstsgroupinvCariModel {
	String mstsgroupinv1Id;
	int noUrut;
	String stsgroupNama;

	MstsgroupinvCariModel({required this.mstsgroupinv1Id, required this.noUrut, 
		required this.stsgroupNama});

	factory MstsgroupinvCariModel.fromJson(Map<String, dynamic> data) {
		return MstsgroupinvCariModel(
			mstsgroupinv1Id: data['mstsgroupinv1Id']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0,
			stsgroupNama: data['stsgroupNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'mstsgroupinv1Id': mstsgroupinv1Id,
		'noUrut': noUrut.toString(),
		'stsgroupNama': stsgroupNama};

}
