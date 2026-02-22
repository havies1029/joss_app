
class NotifeventcariModel {
	String eventDesc;
	String eventNama;
	String notifeventId;

	NotifeventcariModel({required this.eventDesc, required this.eventNama, 
		required this.notifeventId});

	factory NotifeventcariModel.fromJson(Map<String, dynamic> data) {
		return NotifeventcariModel(
			eventDesc: data['eventDesc']??'',
			eventNama: data['eventNama']??'',
			notifeventId: data['notifeventId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'eventDesc': eventDesc,
		'eventNama': eventNama,
		'notifeventId': notifeventId};

}
