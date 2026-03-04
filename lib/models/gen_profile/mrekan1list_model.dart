
class MRekan1ListModel {
	String mbentukcstId;
	String mbidangId;
	String mjnsclientId;
	String mjnskelId;
	String mpekerjaanId;
	String mrekan1Id;
	String mtitleId;
	String rekanNama;
	String bentukNama;
	String bidangNama;
	String jenisDesc;
	String jenisNama;
	String kerjaNama;
	String titleDesc;

	MRekan1ListModel({required this.mbentukcstId, required this.mbidangId, 
		required this.mjnsclientId, required this.mjnskelId, 
		required this.mpekerjaanId, required this.mrekan1Id, 
		required this.mtitleId, required this.rekanNama, 
		required this.bentukNama, required this.bidangNama, 
		required this.jenisDesc, required this.jenisNama, 
		required this.kerjaNama, required this.titleDesc});

	factory MRekan1ListModel.fromJson(Map<String, dynamic> data) {
		return MRekan1ListModel(
			mbentukcstId: data['mbentukcstId']??'',
			mbidangId: data['mbidangId']??'',
			mjnsclientId: data['mjnsclientId']??'',
			mjnskelId: data['mjnskelId']??'',
			mpekerjaanId: data['mpekerjaanId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			mtitleId: data['mtitleId']??'',
			rekanNama: data['rekanNama']??'',
			bentukNama: data['bentukNama']??'',
			bidangNama: data['bidangNama']??'',
			jenisDesc: data['jenisDesc']??'',
			jenisNama: data['jenisNama']??'',
			kerjaNama: data['kerjaNama']??'',
			titleDesc: data['titleDesc']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'mbentukcstId': mbentukcstId,
		'mbidangId': mbidangId,
		'mjnsclientId': mjnsclientId,
		'mjnskelId': mjnskelId,
		'mpekerjaanId': mpekerjaanId,
		'mrekan1Id': mrekan1Id,
		'mtitleId': mtitleId,
		'rekanNama': rekanNama,
		'bentukNama': bentukNama,
		'bidangNama': bidangNama,
		'jenisDesc': jenisDesc,
		'jenisNama': jenisNama,
		'kerjaNama': kerjaNama,
		'titleDesc': titleDesc};

}
