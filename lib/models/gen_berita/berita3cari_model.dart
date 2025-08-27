
class Berita3CariModel {
	String subjudul;
	String berita3Id;
	int noUrut;
	String paragraf;

	Berita3CariModel({required this.subjudul, required this.berita3Id, 
		required this.noUrut, required this.paragraf});

	factory Berita3CariModel.fromJson(Map<String, dynamic> data) {
		return Berita3CariModel(
			subjudul: data['subjudul']??'',
			berita3Id: data['berita3Id']??'',
			noUrut: int.tryParse(data['noUrut'].toString())??0,
			paragraf: data['paragraf']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'subjudul': subjudul,
		'berita3Id': berita3Id,
		'noUrut': noUrut.toString(),
		'paragraf': paragraf};

}
