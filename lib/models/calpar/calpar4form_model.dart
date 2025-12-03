
class Calpar4FormModel {
	String calpar4Id;
	double discNilai;
	double discPersen;
	double premiBi;
	double premiEqvet;
	double premiNet;
	double premiOther;
	double premiPar;
	double premiRsmdcc;
	double premiTsfwd;

	Calpar4FormModel({required this.calpar4Id, required this.discNilai, 
		required this.discPersen, required this.premiBi, 
		required this.premiEqvet, required this.premiNet, 
		required this.premiOther, required this.premiPar, 
		required this.premiRsmdcc, required this.premiTsfwd});

	factory Calpar4FormModel.fromJson(Map<String, dynamic> data) {
		return Calpar4FormModel(
			calpar4Id: data['calpar4Id']??'',
			discNilai: double.tryParse(data['discNilai'].toString())??0,
			discPersen: double.tryParse(data['discPersen'].toString())??0,
			premiBi: double.tryParse(data['premiBi'].toString())??0,
			premiEqvet: double.tryParse(data['premiEqvet'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiOther: double.tryParse(data['premiOther'].toString())??0,
			premiPar: double.tryParse(data['premiPar'].toString())??0,
			premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString())??0,
			premiTsfwd: double.tryParse(data['premiTsfwd'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'calpar4Id': calpar4Id,
		'discNilai': discNilai.toString(),
		'discPersen': discPersen.toString(),
		'premiBi': premiBi.toString(),
		'premiEqvet': premiEqvet.toString(),
		'premiNet': premiNet.toString(),
		'premiOther': premiOther.toString(),
		'premiPar': premiPar.toString(),
		'premiRsmdcc': premiRsmdcc.toString(),
		'premiTsfwd': premiTsfwd.toString()};

}
