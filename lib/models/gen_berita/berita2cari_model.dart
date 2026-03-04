
class Berita2CariModel {
	String berita1Id;
	String berita2Id;
	int noUrut;
	String subjudul;

	Berita2CariModel({required this.berita1Id, required this.berita2Id, 
		required this.noUrut, required this.subjudul});

	factory Berita2CariModel.fromJson(Map<String, dynamic> data) {
		return Berita2CariModel(
			berita1Id: data['berita1Id']??'',
			berita2Id: data['berita2Id']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0,
			subjudul: data['subjudul']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'berita1Id': berita1Id,
		'berita2Id': berita2Id,
		'noUrut': noUrut.toString(),
		'subjudul': subjudul};

}
