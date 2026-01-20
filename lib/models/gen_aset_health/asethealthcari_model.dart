
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

	AsetHealthCariModel({required this.asethealthId, required this.dob,
		required this.jnskel, required this.nama,
		required this.nomor, required this.polisNo,
		required this.posisi, required this.status, required this.filePolisId});

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
			};

}
