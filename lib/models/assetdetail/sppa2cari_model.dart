
class Sppa2CariModel {
	String currDesc;
	String keterangan;
	String objectDesc;
	double premi;
	String sppa1Id;
	String sppa2Id;
	double tsi;

	Sppa2CariModel({required this.currDesc, required this.keterangan, 
		required this.objectDesc, required this.premi, 
		required this.sppa1Id, required this.sppa2Id, 
		required this.tsi});

	factory Sppa2CariModel.fromJson(Map<String, dynamic> data) {
		return Sppa2CariModel(
			currDesc: data['currDesc']??'',
			keterangan: data['keterangan']??'',
			objectDesc: data['objectDesc']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			sppa1Id: data['sppa1Id']??'',
			sppa2Id: data['sppa2Id']??'',
			tsi: double.tryParse(data['tsi'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'currDesc': currDesc,
		'keterangan': keterangan,
		'objectDesc': objectDesc,
		'premi': premi.toString(),
		'sppa1Id': sppa1Id,
		'sppa2Id': sppa2Id,
		'tsi': tsi.toString()};

}
