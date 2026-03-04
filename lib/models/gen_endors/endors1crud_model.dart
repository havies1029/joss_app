
class Endors1CrudModel {
	String notePerubahan;
	String sppa1Id;

	Endors1CrudModel({required this.notePerubahan, required this.sppa1Id});

	factory Endors1CrudModel.fromJson(Map<String, dynamic> data) {
		return Endors1CrudModel(
			notePerubahan: data['notePerubahan']??'',
			sppa1Id: data['sppa1Id']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{'notePerubahan': notePerubahan,
		'sppa1Id': sppa1Id,};

}
