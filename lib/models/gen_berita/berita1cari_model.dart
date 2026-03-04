
class Berita1CariModel {
	String authorFoto;
	String authorNama;
	String berita1Id;
	String gambar;
	int jenis;
	String judul;
	int lamaBaca;
	String sumber;
	String tema;
	DateTime tglTerbit;

	Berita1CariModel({required this.authorFoto, required this.authorNama, 
		required this.berita1Id, required this.gambar, 
		required this.jenis, required this.judul, 
		required this.lamaBaca, required this.sumber, 
		required this.tema, required this.tglTerbit});

	factory Berita1CariModel.fromJson(Map<String, dynamic> data) {
		return Berita1CariModel(
			authorFoto: data['authorFoto']??'',
			authorNama: data['authorNama']??'',
			berita1Id: data['berita1Id']??'',
			gambar: data['gambar']??'',
			jenis: int.tryParse(data['jenis'].toString())??0,
			judul: data['judul']??'',
			lamaBaca: int.tryParse(data['lamaBaca'].toString())??0,
			sumber: data['sumber']??'',
			tema: data['tema']??'',
			tglTerbit: DateTime.tryParse(data['tglTerbit'].toString())??DateTime.now()
		);

	}

	Map<String, dynamic> toJson() =>
		{'authorFoto': authorFoto,
		'authorNama': authorNama,
		'berita1Id': berita1Id,
		'gambar': gambar,
		'jenis': jenis.toString(),
		'judul': judul,
		'lamaBaca': lamaBaca.toString(),
		'sumber': sumber,
		'tema': tema,
		'tglTerbit': tglTerbit.toIso8601String()};

}
