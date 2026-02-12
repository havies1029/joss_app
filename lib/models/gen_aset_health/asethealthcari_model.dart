
class AsetHealthCariModel {
	String asethealthId;
	DateTime dob;
	String jnskel;
	String nama;
	int nomor;
	String polisNo;
	String posisi;
	String status;
	String filePolisId;
	String prosesId;
	String prosesRemarks;
	String prosesSource;
	bool isReaktif;
	bool isRenewal;

	AsetHealthCariModel({required this.asethealthId, required this.dob,
		required this.jnskel, required this.nama,
		required this.nomor, required this.polisNo,
		required this.posisi, required this.status, required this.filePolisId,
		required this.prosesId, required this.prosesRemarks, required this.prosesSource,
		this.isReaktif = false, this.isRenewal = false});

	factory AsetHealthCariModel.fromJson(Map<String, dynamic> data) {
		return AsetHealthCariModel(
			asethealthId: data['asethealthId']??'',
			dob: DateTime.tryParse(data['dob'].toString())??DateTime.now(),
			jnskel: data['jnskel']??'',
			nama: data['nama']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			posisi: data['posisi']??'',
			status: data['status']??'',
			filePolisId: data['filePolisId']??'',
			prosesId: data['prosesId']??'',
			prosesRemarks: data['prosesRemarks']??'',
			prosesSource: data['prosesSource']??'',
			isReaktif: data['isReaktif']??false,
			isRenewal: data['isRenewal']??false,
		);

	}

	Map<String, dynamic> toJson() =>
			{'asethealthId': asethealthId,
				'dob': dob.toIso8601String(),
				'jnskel': jnskel,
				'nama': nama,
				'nomor': nomor.toString(),
				'polisNo': polisNo,
				'posisi': posisi,
				'status': status,
				'filePolisId': filePolisId,
				'prosesId': prosesId,
				'prosesRemarks': prosesRemarks,
				'prosesSource': prosesSource,
				'isReaktif': isReaktif,
				'isRenewal': isRenewal
			};

}
