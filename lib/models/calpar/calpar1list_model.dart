
class Calpar1ListModel {
	String calpar1Id;
	int coverBulan;
	String mjnscoverparId;
	String rkonstruksiojkId;
	String rokupasiId;
	String jenisNama;
	String kelasNama;
	String okupasiDesc;

	Calpar1ListModel({required this.calpar1Id, required this.coverBulan, 
		required this.mjnscoverparId, required this.rkonstruksiojkId, 
		required this.rokupasiId, required this.jenisNama, 
		required this.kelasNama, required this.okupasiDesc});

	factory Calpar1ListModel.fromJson(Map<String, dynamic> data) {
		return Calpar1ListModel(
			calpar1Id: data['calpar1Id']??'',
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			mjnscoverparId: data['mjnscoverparId']??'',
			rkonstruksiojkId: data['rkonstruksiojkId']??'',
			rokupasiId: data['rokupasiId']??'',
			jenisNama: data['jenisNama']??'',
			kelasNama: data['kelasNama']??'',
			okupasiDesc: data['okupasiDesc']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'calpar1Id': calpar1Id,
		'coverBulan': coverBulan.toString(),
		'mjnscoverparId': mjnscoverparId,
		'rkonstruksiojkId': rkonstruksiojkId,
		'rokupasiId': rokupasiId,
		'jenisNama': jenisNama,
		'kelasNama': kelasNama,
		'okupasiDesc': okupasiDesc};

}
