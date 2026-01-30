class Regreaktif1Model {
	final bool isUbah;
	final String notePerubahan;
	final String sppa1Id;

	Regreaktif1Model({
		required this.isUbah,
		required this.notePerubahan,
		required this.sppa1Id,
	});

	factory Regreaktif1Model.fromJson(Map<String, dynamic> data) {
		return Regreaktif1Model(
			isUbah: data['isUbah'] ?? false,
			notePerubahan: data['notePerubahan'] ?? '',
			sppa1Id: data['sppa1Id'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'isUbah': isUbah,
		'notePerubahan': notePerubahan,
		'sppa1Id': sppa1Id,
	};

	/// 👇 ini yang kamu minta
	Regreaktif1Model copyWith({
		bool? isUbah,
		String? notePerubahan,
		String? sppa1Id,
	}) {
		return Regreaktif1Model(
			isUbah: isUbah ?? this.isUbah,
			notePerubahan: notePerubahan ?? this.notePerubahan,
			sppa1Id: sppa1Id ?? this.sppa1Id,
		);
	}
}
