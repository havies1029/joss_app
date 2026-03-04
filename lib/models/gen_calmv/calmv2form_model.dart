class Calmv2FormModel {
	String calmv2Id;
	String calmv1Id;
	bool isEq;
	bool isFlood;
	bool isSrcc;
	bool isTbod;
	bool isTerrorism;
  bool isAw;
	double pad;
	double pap;
	int passangerCount;
	double pll;
	double tpl;

	Calmv2FormModel({
		required this.calmv2Id,
		required this.isEq,
		required this.isFlood,
		required this.isSrcc,
		required this.isTbod,
		required this.isTerrorism,
		required this.isAw,
		required this.pad,
		required this.pap,
		required this.passangerCount,
		required this.pll,
		required this.tpl,
		required this.calmv1Id,
	});

	/// ✅ copyWith: clone + ganti field tertentu
	Calmv2FormModel copyWith({
		String? calmv2Id,
		String? calmv1Id,
		bool? isEq,
		bool? isFlood,
		bool? isSrcc,
		bool? isTbod,
		bool? isTerrorism,
		double? pad,
		double? pap,
		int? passangerCount,
		double? pll,
		double? tpl,
		bool? isAw,
	}) {
		return Calmv2FormModel(
			calmv2Id: calmv2Id ?? this.calmv2Id,
			calmv1Id: calmv1Id ?? this.calmv1Id,
			isEq: isEq ?? this.isEq,
			isFlood: isFlood ?? this.isFlood,
			isSrcc: isSrcc ?? this.isSrcc,
			isTbod: isTbod ?? this.isTbod,
			isTerrorism: isTerrorism ?? this.isTerrorism,
			isAw: isAw ?? this.isAw,
			pad: pad ?? this.pad,
			pap: pap ?? this.pap,
			passangerCount: passangerCount ?? this.passangerCount,
			pll: pll ?? this.pll,
			tpl: tpl ?? this.tpl,
		);
	}

	factory Calmv2FormModel.fromJson(Map<String, dynamic> data) {
    return Calmv2FormModel(
			calmv2Id: data['calmv2Id'] ?? '',
			calmv1Id: data['calmv1Id'] ?? '',
			isEq: data['isEq'] ?? false,
			isFlood: data['isFlood'] ?? false,
			isSrcc: data['isSrcc'] ?? false,
			isTbod: data['isTbod'] ?? false,
			isTerrorism: data['isTerrorism'] ?? false,
			isAw: data['isAw'] ?? false,
			pad: double.tryParse(data['pad'].toString()) ?? 0,
			pap: double.tryParse(data['pap'].toString()) ?? 0,
			passangerCount: int.tryParse(data['passangerCount'].toString()) ?? 0,
			pll: double.tryParse(data['pll'].toString()) ?? 0,
			tpl: double.tryParse(data['tpl'].toString()) ?? 0,
		);
	}

	Map<String, dynamic> toJson() => {
		'calmv2Id': calmv2Id,
		'calmv1Id': calmv1Id,
		'isEq': isEq,
		'isFlood': isFlood,
		'isSrcc': isSrcc,
		'isTbod': isTbod,
		'isTerrorism': isTerrorism,
		'isAw': isAw,
		'pad': pad.toString(),
		'pap': pap.toString(),
		'passangerCount': passangerCount.toString(),
		'pll': pll.toString(),
		'tpl': tpl.toString(),
	};
	factory Calmv2FormModel.empty() {
		return Calmv2FormModel(
			calmv2Id: '',
			calmv1Id: '',
			isEq: false,
			isFlood: false,
			isSrcc: false,
			isTbod: false,
			isTerrorism: false,
			isAw: false,
			pad: 0,
			pap: 0,
			passangerCount: 0,
			pll: 0,
			tpl: 0,
		);
	}
}
