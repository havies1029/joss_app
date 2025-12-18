
class Ar1CrudModel {
	DateTime arTgl;
	String ar1Id;
	DateTime bayarTgl;
	String currId;
	String mcarabayarId;
	double nilaiAr;

	Ar1CrudModel({required this.arTgl, required this.ar1Id, 
		required this.bayarTgl, required this.currId, 
		required this.mcarabayarId, required this.nilaiAr});

	factory Ar1CrudModel.fromJson(Map<String, dynamic> data) {
		return Ar1CrudModel(
			arTgl: DateTime.tryParse(data['arTgl'].toString())??DateTime.now(),
			ar1Id: data['ar1Id']??'',
			bayarTgl: DateTime.tryParse(data['bayarTgl'].toString())??DateTime.now(),
			currId: data['currId']??'',
			mcarabayarId: data['mcarabayarId']??'',
			nilaiAr: double.tryParse(data['nilaiAr'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'arTgl': arTgl.toIso8601String(),
		'ar1Id': ar1Id,
		'bayarTgl': bayarTgl.toIso8601String(),
		'currId': currId,
		'mcarabayarId': mcarabayarId,
		'nilaiAr': nilaiAr.toString()};

}
