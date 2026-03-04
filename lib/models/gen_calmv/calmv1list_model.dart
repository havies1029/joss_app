
class Calmv1ListModel {
	String calmv1Id;
	int coverBulan;
	String currId;
	double harga;
	String mmvgrupojkId;
	String mmvjnscoverId;
	String mmvpakaiId;
	String mwilayahId;
	int thnBuat;
	String coverName;
	String grupNama;
	String pakaiNama;
	String rmatauangNama;
	String wilayahNama;

	Calmv1ListModel({required this.calmv1Id, required this.coverBulan,
		required this.currId, required this.harga,
		required this.mmvgrupojkId, required this.mmvjnscoverId,
		required this.mmvpakaiId, required this.mwilayahId,
		required this.thnBuat, required this.coverName,
		required this.grupNama, required this.pakaiNama,
		required this.rmatauangNama, required this.wilayahNama});

	factory Calmv1ListModel.fromJson(Map<String, dynamic> data) {
		return Calmv1ListModel(
				calmv1Id: data['calmv1Id']??'',
				coverBulan: int.tryParse(data['coverBulan'].toString())??0,
				currId: data['currId']??'',
				harga: double.tryParse(data['harga'].toString())??0,
				mmvgrupojkId: data['mmvgrupojkId']??'',
				mmvjnscoverId: data['mmvjnscoverId']??'',
				mmvpakaiId: data['mmvpakaiId']??'',
				mwilayahId: data['mwilayahId']??'',
				thnBuat: int.tryParse(data['thnBuat'].toString())??0,
				coverName: data['coverName']??'',
				grupNama: data['grupNama']??'',
				pakaiNama: data['pakaiNama']??'',
				rmatauangNama: data['rmatauangNama']??'',
				wilayahNama: data['wilayahNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
			{'calmv1Id': calmv1Id,
				'coverBulan': coverBulan.toString(),
				'currId': currId,
				'harga': harga.toString(),
				'mmvgrupojkId': mmvgrupojkId,
				'mmvjnscoverId': mmvjnscoverId,
				'mmvpakaiId': mmvpakaiId,
				'mwilayahId': mwilayahId,
				'thnBuat': thnBuat.toString(),
				'coverName': coverName,
				'grupNama': grupNama,
				'pakaiNama': pakaiNama,
				'rmatauangNama': rmatauangNama,
				'wilayahNama': wilayahNama};

}
