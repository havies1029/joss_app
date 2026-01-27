
class Regendors1FormModel {
	String notePerubahan;
	String regendors1Id;
	String sppa1Id;

	Regendors1FormModel({
		required this.notePerubahan, this.regendors1Id = '', 
		required this.sppa1Id});

	factory Regendors1FormModel.fromJson(Map<String, dynamic> data) {
		return Regendors1FormModel(
			notePerubahan: data['notePerubahan']??'',
			regendors1Id: data['regendors1Id']??'',
			sppa1Id: data['sppa1Id']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'notePerubahan': notePerubahan,
		'regendors1Id': regendors1Id,
		'sppa1Id': sppa1Id};

}
