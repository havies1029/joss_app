
class KlaimnilaicrudModel {
  String klaim1Id;
	String alasan;
	String? klaimnilaiId;
	int nilaiSuka;

	KlaimnilaicrudModel({required this.klaim1Id, required this.alasan, this.klaimnilaiId, 
		required this.nilaiSuka});

	factory KlaimnilaicrudModel.fromJson(Map<String, dynamic> data) {
		return KlaimnilaicrudModel(
			klaim1Id: data['klaim1Id']??'',
			alasan: data['alasan']??'',
			klaimnilaiId: data['klaimnilaiId']??'',
			nilaiSuka: int.tryParse(data['nilaiSuka'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'klaim1Id': klaim1Id,
		'alasan': alasan,
		'klaimnilaiId': klaimnilaiId,
		'nilaiSuka': nilaiSuka.toString()};

}
