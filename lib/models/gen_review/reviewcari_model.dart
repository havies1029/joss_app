
class ReviewCariModel {
	String instansi;
	bool isAktif;
	String komentar;
	double nilai;
	DateTime reviewTgl;
	String review1Id;
	String reviewer;
	double skala;

	ReviewCariModel({required this.instansi, required this.isAktif, 
		required this.komentar, required this.nilai, 
		required this.reviewTgl, required this.review1Id, 
		required this.reviewer, required this.skala});

	factory ReviewCariModel.fromJson(Map<String, dynamic> data) {
		return ReviewCariModel(
			instansi: data['instansi']??'',
			isAktif: data['isAktif']??'',
			komentar: data['komentar']??'',
			nilai: double.tryParse(data['nilai'].toString())??0,
			reviewTgl: DateTime.tryParse(data['reviewTgl'].toString())??DateTime.now(),
			review1Id: data['review1Id']??'',
			reviewer: data['reviewer']??'',
			skala: double.tryParse(data['skala'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'instansi': instansi,
		'isAktif': isAktif,
		'komentar': komentar,
		'nilai': nilai.toString(),
		'reviewTgl': reviewTgl.toIso8601String(),
		'review1Id': review1Id,
		'reviewer': reviewer,
		'skala': skala.toString()};

}
