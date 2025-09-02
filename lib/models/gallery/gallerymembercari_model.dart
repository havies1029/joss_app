
class GallerymemberCariModel {
	String gallerymemberId;
	String image1Url;
	String text1;
	String text2;
	int urutan;

	GallerymemberCariModel({required this.gallerymemberId, required this.image1Url, 
		required this.text1, required this.text2, 
		required this.urutan});

	factory GallerymemberCariModel.fromJson(Map<String, dynamic> data) {
		return GallerymemberCariModel(
			gallerymemberId: data['gallerymemberId']??'',
			image1Url: data['image1Url']??'',
			text1: data['text1']??'',
			text2: data['text2']??'',
			urutan: int.tryParse(data['urutan'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'gallerymemberId': gallerymemberId,
		'image1Url': image1Url,
		'text1': text1,
		'text2': text2,
		'urutan': urutan.toString()};

}
