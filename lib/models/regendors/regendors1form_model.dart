class Regendors1FormModel {
	String notePerubahan;
	String regendors1Id;
	String sppa1Id;
  String sppa2Id;

	Regendors1FormModel({
		required this.notePerubahan,
		this.regendors1Id = '',
		required this.sppa1Id,
    required this.sppa2Id,
	});

	Regendors1FormModel copyWith({
		String? notePerubahan,
		String? regendors1Id,
		String? sppa1Id,
    String? sppa2Id,
	}) {
		return Regendors1FormModel(
			notePerubahan: notePerubahan ?? this.notePerubahan,
			regendors1Id: regendors1Id ?? this.regendors1Id,
			sppa1Id: sppa1Id ?? this.sppa1Id,
      sppa2Id: sppa2Id ?? this.sppa2Id,
		);
	}

	factory Regendors1FormModel.fromJson(Map<String, dynamic> data) {
		return Regendors1FormModel(
			notePerubahan: data['notePerubahan'] ?? '',
			regendors1Id: data['regendors1Id'] ?? '',
			sppa1Id: data['sppa1Id'] ?? '',
      sppa2Id: data['sppa2Id'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'notePerubahan': notePerubahan,
		'regendors1Id': regendors1Id,
		'sppa1Id': sppa1Id, 
    'sppa2Id': sppa2Id,
	};
}
