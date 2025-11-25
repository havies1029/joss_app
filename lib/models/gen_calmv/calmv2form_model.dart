
class Calmv2FormModel {
		double aw;
		String calmv2Id;
		String calmv1Id;
		bool isEq;
		bool isFlood;
		bool isSrcc;
		bool isTbod;
		bool isTerrorism;
		double pad;
		double pap;
		int passangerCount;
		double pll;
		double tpl;

		Calmv2FormModel({required this.aw, required this.calmv2Id,
			required this.isEq, required this.isFlood,
			required this.isSrcc, required this.isTbod,
			required this.isTerrorism, required this.pad,
			required this.pap, required this.passangerCount,
			required this.pll, required this.tpl, required this.calmv1Id,});

		factory Calmv2FormModel.fromJson(Map<String, dynamic> data) {
			return Calmv2FormModel(
				aw: double.tryParse(data['aw'].toString())??0,
				calmv2Id: data['calmv2Id']??'',
					calmv1Id: data['calmv1Id'] ?? '',
				isEq: data['isEq']??'',
				isFlood: data['isFlood']??'',
				isSrcc: data['isSrcc']??'',
				isTbod: data['isTbod']??'',
				isTerrorism: data['isTerrorism']??'',
			pad: double.tryParse(data['pad'].toString())??0,
			pap: double.tryParse(data['pap'].toString())??0,
			passangerCount: int.tryParse(data['passangerCount'].toString())??0,
			pll: double.tryParse(data['pll'].toString())??0,
			tpl: double.tryParse(data['tpl'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'aw': aw.toString(),
		'calmv2Id': calmv2Id,
			'calmv1Id': calmv1Id,
		'isEq': isEq,
		'isFlood': isFlood,
		'isSrcc': isSrcc,
		'isTbod': isTbod,
		'isTerrorism': isTerrorism,
		'pad': pad.toString(),
		'pap': pap.toString(),
		'passangerCount': passangerCount.toString(),
		'pll': pll.toString(),
		'tpl': tpl.toString()};

}
