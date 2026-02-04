
class Calpar4FormModel {

	String calpar1Id;
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
	double premiTotal;
	double ratePar;
	double rateRsmdcc;
	double rateTsfwd;
	double rateEqvet;
	double rateOther;
	double rateTotal;
	double biayaPolis;

	Calpar4FormModel({required this.calpar1Id, required this.calpar4Id, required this.discNilai,
		required this.discPersen, required this.premiBi,
		required this.premiEqvet, required this.premiNet,
		required this.premiOther, required this.premiPar,
		required this.premiRsmdcc, required this.premiTsfwd,
		this.premiTotal = 0,
		this.ratePar = 0,
		this.rateRsmdcc = 0,
		this.rateTsfwd = 0,
		this.rateEqvet = 0,
		this.rateOther = 0,
		this.rateTotal = 0,
		this.biayaPolis = 0,});

	factory Calpar4FormModel.fromJson(Map<String, dynamic> data) {
		return Calpar4FormModel(
			calpar1Id: data['calpar1Id']??'',
			calpar4Id: data['calpar4Id']??'',
			discNilai: double.tryParse(data['discNilai'].toString())??0,
			discPersen: double.tryParse(data['discPersen'].toString())??0,
			premiBi: double.tryParse(data['premiBi'].toString())??0,
			premiEqvet: double.tryParse(data['premiEqvet'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiOther: double.tryParse(data['premiOther'].toString())??0,
			premiPar: double.tryParse(data['premiPar'].toString())??0,
			premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString())??0,
			premiTsfwd: double.tryParse(data['premiTsfwd'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,
			ratePar: double.tryParse(data['ratePar'].toString())??0,
			rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString())??0,
			rateTsfwd: double.tryParse(data['rateTsfwd'].toString())??0,
			rateEqvet: double.tryParse(data['rateEqvet'].toString())??0,
			rateOther: double.tryParse(data['rateOther'].toString())??0,
			rateTotal: double.tryParse(data['rateTotal'].toString())??0,
			biayaPolis: double.tryParse(data['biayaPolis'].toString())??0,
		);

	}

	Map<String, dynamic> toJson() =>
			{'calpar1Id': calpar1Id,
				'calpar4Id': calpar4Id,
				'discNilai': discNilai.toString(),
				'discPersen': discPersen.toString(),
				'premiBi': premiBi.toString(),
				'premiEqvet': premiEqvet.toString(),
				'premiNet': premiNet.toString(),
				'premiOther': premiOther.toString(),
				'premiPar': premiPar.toString(),
				'premiRsmdcc': premiRsmdcc.toString(),
				'premiTsfwd': premiTsfwd.toString(),
				'premiTotal': premiTotal.toString(),
				'ratePar': ratePar.toString(),
				'rateRsmdcc': rateRsmdcc.toString(),
				'rateTsfwd': rateTsfwd.toString(),
				'rateEqvet': rateEqvet.toString(),
				'rateOther': rateOther.toString(),
				'rateTotal': rateTotal.toString(),
				'biayaPolis': biayaPolis.toString(),
			};
}
