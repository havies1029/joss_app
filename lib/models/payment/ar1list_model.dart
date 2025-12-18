
class Ar1ListModel {
	DateTime arTgl;
	String ar1Id;
	DateTime bayarTgl;
	String currId;
	String inv1Id;
	String mcarabayarId;
	String mrekanId;
	String mstsbayarId;
	double nilaiAr;

	Ar1ListModel({required this.arTgl, required this.ar1Id, 
		required this.bayarTgl, required this.currId, 
		required this.inv1Id, required this.mcarabayarId, 
		required this.mrekanId, required this.mstsbayarId, 
		required this.nilaiAr});

	factory Ar1ListModel.fromJson(Map<String, dynamic> data) {
		return Ar1ListModel(
			arTgl: DateTime.tryParse(data['arTgl'].toString())??DateTime.now(),
			ar1Id: data['ar1Id']??'',
			bayarTgl: DateTime.tryParse(data['bayarTgl'].toString())??DateTime.now(),
			currId: data['currId']??'',
			inv1Id: data['inv1Id']??'',
			mcarabayarId: data['mcarabayarId']??'',
			mrekanId: data['mrekanId']??'',
			mstsbayarId: data['mstsbayarId']??'',
			nilaiAr: double.tryParse(data['nilaiAr'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'arTgl': arTgl.toIso8601String(),
		'ar1Id': ar1Id,
		'bayarTgl': bayarTgl.toIso8601String(),
		'currId': currId,
		'inv1Id': inv1Id,
		'mcarabayarId': mcarabayarId,
		'mrekanId': mrekanId,
		'mstsbayarId': mstsbayarId,
		'nilaiAr': nilaiAr.toString()};

}
