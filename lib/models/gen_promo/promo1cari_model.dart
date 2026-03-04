
class Promo1CariModel {
	String hargaCurrId;
	String hargaSatuan;
	double hargaStart;
	String mcobappId;
	String promo1Id;
	String ringkasan;
	String cobNama;
	String curr;

	Promo1CariModel({required this.hargaCurrId, required this.hargaSatuan, 
		required this.hargaStart, required this.mcobappId, 
		required this.promo1Id, required this.ringkasan, 
		required this.cobNama, required this.curr});

	factory Promo1CariModel.fromJson(Map<String, dynamic> data) {
		return Promo1CariModel(
			hargaCurrId: data['hargaCurrId']??'',
			hargaSatuan: data['hargaSatuan']??'',
			hargaStart: double.tryParse(data['hargaStart'].toString())??0,
			mcobappId: data['mcobappId']??'',
			promo1Id: data['promo1Id']??'',
			ringkasan: data['ringkasan']??'',
			cobNama: data['cobNama']??'',
			curr: data['curr']??''
		);

	}

	get isPopular => true;

	Map<String, dynamic> toJson() =>
		{'hargaCurrId': hargaCurrId,
		'hargaSatuan': hargaSatuan,
		'hargaStart': hargaStart.toString(),
		'mcobappId': mcobappId,
		'promo1Id': promo1Id,
		'ringkasan': ringkasan,
		'cobNama': cobNama,
		'curr': curr};

}
