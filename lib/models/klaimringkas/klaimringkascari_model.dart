
class KlaimringkasCariModel {
	String cobNama;
	String currNama;
	double klaimAmount;
	int klaimQty;
	int nourut;
	String cobKlaimId;

	KlaimringkasCariModel({required this.cobNama, required this.currNama, 
		required this.klaimAmount, required this.klaimQty, 
		required this.nourut, required this.cobKlaimId});
	factory KlaimringkasCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimringkasCariModel(
			cobNama: data['cobNama']??'',
			currNama: data['currNama']??'',
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaimQty: int.tryParse(data['klaimQty'].toString())??0,
			nourut: int.tryParse(data['nourut'].toString())??0,
			cobKlaimId: data['cobKlaimId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobNama': cobNama,
		'currNama': currNama,
		'klaimAmount': klaimAmount.toString(),
		'klaimQty': klaimQty.toString(),
		'nourut': nourut.toString(),
		'cobKlaimId': cobKlaimId};

}
