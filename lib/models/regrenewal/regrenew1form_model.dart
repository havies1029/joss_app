class Regrenew1FormModel {
	final bool isUbah;
	final String notePerubahan;
	final String sppa1Id;

	Regrenew1FormModel({
		required this.isUbah,
		required this.notePerubahan,
		required this.sppa1Id,
	});

	factory Regrenew1FormModel.fromJson(Map<String, dynamic> data) {
		return Regrenew1FormModel(
			isUbah: data['isUbah'] ?? false, // <-- jangan ''
			notePerubahan: data['notePerubahan'] ?? '',
			sppa1Id: data['sppa1Id'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'isUbah': isUbah,
		'notePerubahan': notePerubahan,
		'sppa1Id': sppa1Id,
	};

	Regrenew1FormModel copyWith({
		bool? isUbah,
		String? notePerubahan,
		String? sppa1Id,
	}) {
		return Regrenew1FormModel(
			isUbah: isUbah ?? this.isUbah,
			notePerubahan: notePerubahan ?? this.notePerubahan,
			sppa1Id: sppa1Id ?? this.sppa1Id,
		);
	}
}
