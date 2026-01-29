
class Regpar5FormModel {
	String regpar1Id;
	double diskonNilai;
	double diskonPersen;
	double premiEqvet;
	double premiNet;
	double premiOther;
	double premiPar;
	double premiRsmdcc;
	double premiTotal;
	double premiTsfwd;
	String regpar5Id;

	Regpar5FormModel({required this.diskonNilai, required this.diskonPersen,
		required this.premiEqvet, required this.premiNet,
		required this.premiOther, required this.premiPar,
		required this.premiRsmdcc, required this.premiTotal,
		required this.premiTsfwd, required this.regpar5Id, required this.regpar1Id});

	factory Regpar5FormModel.fromJson(Map<String, dynamic> data) {
		return Regpar5FormModel(
				diskonNilai: double.tryParse(data['diskonNilai'].toString()) ?? 0,
				diskonPersen: double.tryParse(data['diskonPersen'].toString()) ?? 0,
				premiEqvet: double.tryParse(data['premiEqvet'].toString()) ?? 0,
				premiNet: double.tryParse(data['premiNet'].toString()) ?? 0,
				premiOther: double.tryParse(data['premiOther'].toString()) ?? 0,
				premiPar: double.tryParse(data['premiPar'].toString()) ?? 0,
				premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString()) ?? 0,
				premiTotal: double.tryParse(data['premiTotal'].toString()) ?? 0,
				premiTsfwd: double.tryParse(data['premiTsfwd'].toString()) ?? 0,
				regpar5Id: data['regpar5Id'] ?? '',
				regpar1Id: data['regpar1Id'] ?? ''
		);
	}

	Map<String, dynamic> toJson() =>
			{'diskonNilai': diskonNilai.toString(),
				'diskonPersen': diskonPersen.toString(),
				'premiEqvet': premiEqvet.toString(),
				'premiNet': premiNet.toString(),
				'premiOther': premiOther.toString(),
				'premiPar': premiPar.toString(),
				'premiRsmdcc': premiRsmdcc.toString(),
				'premiTotal': premiTotal.toString(),
				'premiTsfwd': premiTsfwd.toString(),
				'regpar5Id': regpar5Id,
				'regpar1Id': regpar1Id};

	Regpar5FormModel copyWith({
		String? regpar1Id,
		double? diskonNilai,
		double? diskonPersen,
		double? premiEqvet,
		double? premiNet,
		double? premiOther,
		double? premiPar,
		double? premiRsmdcc,
		double? premiTotal,
		double? premiTsfwd,
		String? regpar5Id,
	}) {
		return Regpar5FormModel(
			regpar1Id: regpar1Id ?? this.regpar1Id,
			diskonNilai: diskonNilai ?? this.diskonNilai,
			diskonPersen: diskonPersen ?? this.diskonPersen,
			premiEqvet: premiEqvet ?? this.premiEqvet,
			premiNet: premiNet ?? this.premiNet,
			premiOther: premiOther ?? this.premiOther,
			premiPar: premiPar ?? this.premiPar,
			premiRsmdcc: premiRsmdcc ?? this.premiRsmdcc,
			premiTotal: premiTotal ?? this.premiTotal,
			premiTsfwd: premiTsfwd ?? this.premiTsfwd,
			regpar5Id: regpar5Id ?? this.regpar5Id,
		);
	}
}

