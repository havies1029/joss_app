
class GalleryeventCariModel {
	String eventDesc;
	String eventNama;
	String galleryUrl;
	String galleryeventId;
	int urutan;

	GalleryeventCariModel({required this.eventDesc, required this.eventNama, 
		required this.galleryUrl, required this.galleryeventId, 
		required this.urutan});

	factory GalleryeventCariModel.fromJson(Map<String, dynamic> data) {
		return GalleryeventCariModel(
			eventDesc: data['eventDesc']??'',
			eventNama: data['eventNama']??'',
			galleryUrl: data['galleryUrl']??'',
			galleryeventId: data['galleryeventId']??'',
			urutan: int.tryParse(data['urutan'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'eventDesc': eventDesc,
		'eventNama': eventNama,
		'galleryUrl': galleryUrl,
		'galleryeventId': galleryeventId,
		'urutan': urutan.toString()};

}
