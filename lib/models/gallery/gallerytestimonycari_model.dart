
class GallerytestimonyCariModel {
	String gallerytestimonyId;
	String image1Url;
	String text1;
	String text2;
	String text3;
	int urutan;

	GallerytestimonyCariModel({required this.gallerytestimonyId, required this.image1Url, 
		required this.text1, required this.text2, 
		required this.text3, required this.urutan});

	factory GallerytestimonyCariModel.fromJson(Map<String, dynamic> data) {
		return GallerytestimonyCariModel(
			gallerytestimonyId: data['gallerytestimonyId']??'',
			image1Url: data['image1Url']??'',
			text1: data['text1']??'',
			text2: data['text2']??'',
			text3: data['text3']??'',
			urutan: int.tryParse(data['urutan'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'gallerytestimonyId': gallerytestimonyId,
		'image1Url': image1Url,
		'text1': text1,
		'text2': text2,
		'text3': text3,
		'urutan': urutan.toString()};

  Map<String, String> toMap() {
    return {
      'image': image1Url,
      'name': text1,
      'quote': text2,
    };
  }

}
