class KlaimdetailCariModel {
	String cobId;
	String cobNama;
	String cobDesc; // ✅ tambahan
	String curr;
	double klaimAmount;
	String klaim1Id;
	String noPolis;
	int nourut;
	String statusDesc;
	DateTime tglKejadian;

	KlaimdetailCariModel({
		required this.cobId,
		required this.cobNama,
		required this.cobDesc, // ✅ masuk constructor
		required this.curr,
		required this.klaimAmount,
		required this.klaim1Id,
		required this.noPolis,
		required this.nourut,
		required this.statusDesc,
		required this.tglKejadian
	});

	factory KlaimdetailCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimdetailCariModel(
			cobId: data['cobId']??'',
			cobNama: data['cobNama']??'',
			cobDesc: data['cobDesc']??'',
			curr: data['curr']??'',
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaim1Id: data['klaim1Id']??'',
			noPolis: data['noPolis']??'',
			nourut: int.tryParse(data['nourut'].toString())??0,
			statusDesc: data['statusDesc']??'',
			tglKejadian: DateTime.tryParse(data['tglKejadian'].toString())??DateTime.now()
		);
	}

	Map<String, dynamic> toJson() =>
		{
		'cobId': cobId,
		'cobNama': cobNama,
		'cobDesc': cobDesc,
		'curr': curr,
		'klaimAmount': klaimAmount.toString(),
		'klaim1Id': klaim1Id,
		'noPolis': noPolis,
		'nourut': nourut.toString(),
		'statusDesc': statusDesc,
		'tglKejadian': tglKejadian.toIso8601String()
		};
}