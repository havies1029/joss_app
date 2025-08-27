
class MRekanGeneralCmpListModel {
	String mbentukcstId;
	String mbidangId;
	String mrekan1Id;
	String rekanNama;
	String bentukNama;
	String bidangNama;

	MRekanGeneralCmpListModel({required this.mbentukcstId, required this.mbidangId, 
		required this.mrekan1Id, required this.rekanNama, 
		required this.bentukNama, required this.bidangNama});

	factory MRekanGeneralCmpListModel.fromJson(Map<String, dynamic> data) {
		return MRekanGeneralCmpListModel(
			mbentukcstId: data['mbentukcstId']??'',
			mbidangId: data['mbidangId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			rekanNama: data['rekanNama']??'',
			bentukNama: data['bentukNama']??'',
			bidangNama: data['bidangNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'mbentukcstId': mbentukcstId,
		'mbidangId': mbidangId,
		'mrekan1Id': mrekan1Id,
		'rekanNama': rekanNama,
		'bentukNama': bentukNama,
		'bidangNama': bidangNama};

}
