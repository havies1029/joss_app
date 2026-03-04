
class GuestsCrudModel {
	String email;
	String guestsId;
	String name;
	String phone;
	String sessionToken;

	GuestsCrudModel({required this.email, required this.guestsId, 
		required this.name, required this.phone, 
		required this.sessionToken});

	factory GuestsCrudModel.fromJson(Map<String, dynamic> data) {
		return GuestsCrudModel(
			email: data['email']??'',
			guestsId: data['guestsId']??'',
			name: data['name']??'',
			phone: data['phone']??'',
			sessionToken: data['sessionToken']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'email': email,
		'guestsId': guestsId,
		'name': name,
		'phone': phone,
		'sessionToken': sessionToken};

}
