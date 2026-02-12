class AuthorModel {
	String id;  
	String firstname;
	String lastname;
	String? imageurl;

	AuthorModel({required this.firstname, required this.id, 
		this.imageurl, required this.lastname});

	factory AuthorModel.fromJson(Map<String, dynamic> data) =>
		AuthorModel(
			firstname: data['firstname'],
			id: data['id'],
			imageurl: data['imageurl'],
			lastname: data['lastname']??''
		);

	Map<String, dynamic> toJson() =>
		{'firstname': firstname,
		'id': id,
		'imageurl': imageurl,
		'lastname': lastname};

}
