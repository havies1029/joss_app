
class CobCariModel {
	String cobIcon;
	String cobNama;
	String mCobApp1Id;
	int noUrut;

	CobCariModel({required this.cobIcon, required this.cobNama,
		required this.mCobApp1Id,
		required this.noUrut});

	factory CobCariModel.fromJson(Map<String, dynamic> data) {
		return CobCariModel(
			cobIcon: data['cobIcon']??'',
			cobNama: data['cobNama']??'',
			mCobApp1Id: data['mCobApp1Id']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobIcon': cobIcon,
		'cobNama': cobNama,
		'mCobApp1Id': mCobApp1Id,
		'noUrut': noUrut.toString()};

}
