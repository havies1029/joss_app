
class KlaimmvdoccrudModel {
	String caption;
	String jenisDocLain;
	String klaim5Id;

	KlaimmvdoccrudModel({required this.caption, 
		required this.jenisDocLain, required this.klaim5Id});

	factory KlaimmvdoccrudModel.fromJson(Map<String, dynamic> data) {
		return KlaimmvdoccrudModel(
			caption: data['caption']??'',
			jenisDocLain: data['jenisDocLain']??'',
			klaim5Id: data['klaim5Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'caption': caption,
		'jenisDocLain': jenisDocLain,
		'klaim5Id': klaim5Id};

}
