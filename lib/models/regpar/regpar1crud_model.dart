class Regpar1CrudModel {
	String regpar1Id;
	String ttgAlamat;
	String ttgNama;

	Regpar1CrudModel({
		required this.regpar1Id,
		required this.ttgAlamat,
		required this.ttgNama,
	});

	factory Regpar1CrudModel.fromJson(Map<String, dynamic> data) {
		return Regpar1CrudModel(
			regpar1Id: data['regpar1Id'] ?? '',
			ttgAlamat: data['ttgAlamat'] ?? '',
			ttgNama: data['ttgNama'] ?? '',
		);
	}

	Regpar1CrudModel copyWith({
		String? regpar1Id,
		String? ttgAlamat,
		String? ttgNama,
	}) {
		return Regpar1CrudModel(
			regpar1Id: regpar1Id ?? this.regpar1Id,
			ttgAlamat: ttgAlamat ?? this.ttgAlamat,
			ttgNama: ttgNama ?? this.ttgNama,
		);
	}

	Map<String, dynamic> toJson() => {
		'regpar1Id': regpar1Id,
		'ttgAlamat': ttgAlamat,
		'ttgNama': ttgNama,
	};
}
