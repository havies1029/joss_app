
class MRekanPajakListModel {
	String alamat1;
	String mkotaId;
	String mpropinsiId;
	String mrekan1Id;
	String mrekanpajakId;
	String npwpNo;
	String rkodeposId;
	String kODEPOSNO;
	String mnegaraId;

	MRekanPajakListModel({required this.alamat1, required this.mkotaId, 
		required this.mpropinsiId, required this.mrekan1Id, 
		required this.mrekanpajakId, required this.npwpNo, 
		required this.rkodeposId, required this.kODEPOSNO, 
		required this.mnegaraId});

	factory MRekanPajakListModel.fromJson(Map<String, dynamic> data) {
		return MRekanPajakListModel(
			alamat1: data['alamat1']??'',
			mkotaId: data['mkotaId']??'',
			mpropinsiId: data['mpropinsiId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			mrekanpajakId: data['mrekanpajakId']??'',
			npwpNo: data['npwpNo']??'',
			rkodeposId: data['rkodeposId']??'',
			kODEPOSNO: data['kODEPOSNO']??'',
			mnegaraId: data['mnegaraId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{'alamat1': alamat1,
		'mkotaId': mkotaId,
		'mpropinsiId': mpropinsiId,
		'mrekan1Id': mrekan1Id,
		'mrekanpajakId': mrekanpajakId,
		'npwpNo': npwpNo,
		'rkodeposId': rkodeposId,
		'kODEPOSNO': kODEPOSNO,
		'mnegaraId': mnegaraId,};

}
