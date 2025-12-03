
class AsetHealthCariModel {
	String asethealthId;
	String namaPeserta;
	String benefit;
	DateTime dob;
	String jnskel;
	String nama;
	int nomor;
	String polisNo;
	String posisi;
	String status;

	AsetHealthCariModel({required this.asethealthId, required this.namaPeserta, required this.benefit ,required this.dob,
		required this.jnskel, required this.nama, 
		required this.nomor, required this.polisNo, 
		required this.posisi, required this.status});

	factory AsetHealthCariModel.fromJson(Map<String, dynamic> data) {
		return AsetHealthCariModel(
			asethealthId: data['asethealthId']??'',
			namaPeserta: data['namaPeserta']??'',
			benefit: data['benefit']??'',
			dob: DateTime.tryParse(data['dob'].toString())??DateTime.now(),
			jnskel: data['jnskel']??'',
			nama: data['nama']??'',
			nomor: int.tryParse(data['nomor'].toString())??0,
			polisNo: data['polisNo']??'',
			posisi: data['posisi']??'',
			status: data['status']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'asethealthId': asethealthId,
		'namaPeserta' : namaPeserta,
		'benefit' : benefit,
		'dob': dob.toIso8601String(),
		'jnskel': jnskel,
		'nama': nama,
		'nomor': nomor.toString(),
		'polisNo': polisNo,
		'posisi': posisi,
		'status': status
		};

}
