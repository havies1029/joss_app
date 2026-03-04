
class SimulmvListModel {
	double aw;
	int coverBulan;
	double harga;
	bool isEq;
	bool isFlood;
	bool isSrcc;
	bool isTerrorism;
	String mmvgrupojkId;
	String mmvjnscoverId;
	String mwilayahId;
	double pad;
	double pap;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	double pll;
	double premiAdd;
	double premiCasco;
	double premiTotal;
	String remarks;
	String rmatauangKode;
	String salesId;
	String simulmv1Id;
	String theinsured;
	int thnBuat;
	double tpl;
	String coverName;
	String grupNama;
	String pARENTID;
	String rMATAUANGNAMA;
	String wilayahNama;

	SimulmvListModel({required this.aw, required this.coverBulan, 
		required this.harga, required this.isEq, 
		required this.isFlood, required this.isSrcc, 
		required this.isTerrorism, required this.mmvgrupojkId, 
		required this.mmvjnscoverId, required this.mwilayahId, 
		required this.pad, required this.pap, 
		required this.periodeAkhir, required this.periodeMulai, 
		required this.pll, required this.premiAdd, 
		required this.premiCasco, required this.premiTotal, 
		required this.remarks, required this.rmatauangKode, 
		required this.salesId, required this.simulmv1Id, 
		required this.theinsured, required this.thnBuat, 
		required this.tpl, required this.coverName, 
		required this.grupNama, required this.pARENTID, 
		required this.rMATAUANGNAMA, required this.wilayahNama});

	factory SimulmvListModel.fromJson(Map<String, dynamic> data) {
		return SimulmvListModel(
			aw: double.tryParse(data['aw'].toString())??0,
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			harga: double.tryParse(data['harga'].toString())??0,
			isEq: data['isEq']??'',
			isFlood: data['isFlood']??'',
			isSrcc: data['isSrcc']??'',
			isTerrorism: data['isTerrorism']??'',
			mmvgrupojkId: data['mmvgrupojkId']??'',
			mmvjnscoverId: data['mmvjnscoverId']??'',
			mwilayahId: data['mwilayahId']??'',
			pad: double.tryParse(data['pad'].toString())??0,
			pap: double.tryParse(data['pap'].toString())??0,
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			pll: double.tryParse(data['pll'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,
			remarks: data['remarks']??'',
			rmatauangKode: data['rmatauangKode']??'',
			salesId: data['salesId']??'',
			simulmv1Id: data['simulmv1Id']??'',
			theinsured: data['theinsured']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			tpl: double.tryParse(data['tpl'].toString())??0,
			coverName: data['coverName']??'',
			grupNama: data['grupNama']??'',
			pARENTID: data['pARENTID']??'',
			rMATAUANGNAMA: data['rMATAUANGNAMA']??'',
			wilayahNama: data['wilayahNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'aw': aw.toString(),
		'coverBulan': coverBulan.toString(),
		'harga': harga.toString(),
		'isEq': isEq,
		'isFlood': isFlood,
		'isSrcc': isSrcc,
		'isTerrorism': isTerrorism,
		'mmvgrupojkId': mmvgrupojkId,
		'mmvjnscoverId': mmvjnscoverId,
		'mwilayahId': mwilayahId,
		'pad': pad.toString(),
		'pap': pap.toString(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'pll': pll.toString(),
		'premiAdd': premiAdd.toString(),
		'premiCasco': premiCasco.toString(),
		'premiTotal': premiTotal.toString(),
		'remarks': remarks,
		'rmatauangKode': rmatauangKode,
		'salesId': salesId,
		'simulmv1Id': simulmv1Id,
		'theinsured': theinsured,
		'thnBuat': thnBuat.toString(),
		'tpl': tpl.toString(),
		'coverName': coverName,
		'grupNama': grupNama,
		'pARENTID': pARENTID,
		'rMATAUANGNAMA': rMATAUANGNAMA,
		'wilayahNama': wilayahNama};

}
