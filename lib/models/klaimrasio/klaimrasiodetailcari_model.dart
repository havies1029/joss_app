
class KlaimrasiodetailCariModel {
	String cobNama;
	String curr;
	double klaimAmount;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	String polisNo;
	double premiAmount;
	double rasio;
	String sppa1Id;
	String cobId;
  int nourut;

	KlaimrasiodetailCariModel({required this.cobNama, required this.curr, 
		required this.klaimAmount, required this.periodeAkhir, 
		required this.periodeMulai, required this.polisNo, 
		required this.premiAmount, required this.rasio, 
		required this.sppa1Id, required this.cobId, required this.nourut});

	factory KlaimrasiodetailCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimrasiodetailCariModel(
			cobNama: data['cobNama']??'',
			curr: data['curr']??'',
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			polisNo: data['polisNo']??'',
			premiAmount: double.tryParse(data['premiAmount'].toString())??0,
			rasio: double.tryParse(data['rasio'].toString())??0,
			sppa1Id: data['sppa1Id']??'',
			cobId: data['cobId']??'',
      nourut: int.tryParse(data['nourut'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobNama': cobNama,
		'curr': curr,
		'klaimAmount': klaimAmount.toString(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'polisNo': polisNo,
		'premiAmount': premiAmount.toString(),
		'rasio': rasio.toString(),
		'sppa1Id': sppa1Id,
		'cobId': cobId,
    'nourut': nourut.toString()
    };

}
