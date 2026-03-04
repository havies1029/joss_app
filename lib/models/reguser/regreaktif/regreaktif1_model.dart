
class Regreaktif1Model {
	bool isUbah;
	String notePerubahan;
	String sppa1Id;

	Regreaktif1Model({required this.isUbah, 
		required this.notePerubahan, required this.sppa1Id});

	factory Regreaktif1Model.fromJson(Map<String, dynamic> data) {
		return Regreaktif1Model(
			isUbah: data['isUbah']??'',
			notePerubahan: data['notePerubahan']??'',
			sppa1Id: data['sppa1Id']??''
		);
	}

	Map<String, dynamic> toJson() =>
		{'isUbah': isUbah,
		'notePerubahan': notePerubahan,
		'sppa1Id': sppa1Id};

}
