
class MRekanGeneralIdvListModel {
	String mjnsclientId;
	String mjnskelId;
	String mpekerjaanId;
	String mrekan1Id;
	String rekanNama;
	String kerjaNama;

	MRekanGeneralIdvListModel({required this.mjnsclientId, required this.mjnskelId, 
		required this.mpekerjaanId, required this.mrekan1Id, 
		required this.rekanNama, required this.kerjaNama});

	factory MRekanGeneralIdvListModel.fromJson(Map<String, dynamic> data) {
		return MRekanGeneralIdvListModel(
			mjnsclientId: data['mjnsclientId']??'',
			mjnskelId: data['mjnskelId']??'',
			mpekerjaanId: data['mpekerjaanId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			rekanNama: data['rekanNama']??'',
			kerjaNama: data['kerjaNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'mjnsclientId': mjnsclientId,
		'mjnskelId': mjnskelId,
		'mpekerjaanId': mpekerjaanId,
		'mrekan1Id': mrekan1Id,
		'rekanNama': rekanNama,
		'kerjaNama': kerjaNama};

}
