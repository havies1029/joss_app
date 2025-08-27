
class MRekanContactListModel {
	String alamat1;
	String email;
	String mkotaId;
	String mpropinsiId;
	String mrekan1Id;
	String mrekancontact1Id;
	String rkodeposId;
	String telp;
	String kODEPOSNO;
	String mnegaraId;

	MRekanContactListModel({required this.alamat1, required this.email, 
		required this.mkotaId, required this.mpropinsiId, 
		required this.mrekan1Id, required this.mrekancontact1Id, 
		required this.rkodeposId, required this.telp, 
		required this.kODEPOSNO, required this.mnegaraId, });

	factory MRekanContactListModel.fromJson(Map<String, dynamic> data) {
		return MRekanContactListModel(
			alamat1: data['alamat1']??'',
			email: data['email']??'',
			mkotaId: data['mkotaId']??'',
			mpropinsiId: data['mpropinsiId']??'',
			mrekan1Id: data['mrekan1Id']??'',
			mrekancontact1Id: data['mrekancontact1Id']??'',
			rkodeposId: data['rkodeposId']??'',
			telp: data['telp']??'',
			kODEPOSNO: data['kODEPOSNO']??'',
			mnegaraId: data['mnegaraId']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{'alamat1': alamat1,
		'email': email,
		'mkotaId': mkotaId,
		'mpropinsiId': mpropinsiId,
		'mrekan1Id': mrekan1Id,
		'mrekancontact1Id': mrekancontact1Id,
		'rkodeposId': rkodeposId,
		'telp': telp,
		'kODEPOSNO': kODEPOSNO,
		'mnegaraId': mnegaraId,};

}
