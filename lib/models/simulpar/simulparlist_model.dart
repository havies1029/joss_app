
class SimulparListModel {
	double biIndexRate;
	int coverBulan;
	double discNilai;
	double discPersen;
	String kab2zonagempaId;
	String mbiindemnityojkId;
	String mtarifojkbanjirparId;
	String mwilayahId;
	double premiBi;
	double premiBiEqvet;
	double premiBiOther;
	double premiBiPar;
	double premiBiRsmdcc;
	double premiBiTsfwd;
	double premiEqvet;
	double premiNet;
	double premiNonBi;
	double premiOther;
	double premiPar;
	double premiRsmdcc;
	double premiTotal;
	double premiTsfwd;
	double rateEqvet;
	double rateOther;
	double ratePar;
	double rateRsmdcc;
	double rateTotal;
	double rateTsfwd;
	String rkonstruksiojkId;
	String rmatauangKode;
	String rokupasiId;
	double siBi;
	double siBuilding;
	double siContent;
	double siMachinery;
	double siOther;
	double siStock;
	String simulpar1Id;
	double stockAdjustable;
	String theinsured;
	String kabupaten;
	String kelasNama;
	String keterangan;
	String kriteria;
	String okupasiDesc;
	String rMATAUANGNAMA;
	String wilayahNama;

	SimulparListModel({required this.biIndexRate, required this.coverBulan, 
		required this.discNilai, required this.discPersen, 
		required this.kab2zonagempaId, required this.mbiindemnityojkId, 
		required this.mtarifojkbanjirparId, required this.mwilayahId, 
		required this.premiBi, required this.premiBiEqvet, 
		required this.premiBiOther, required this.premiBiPar, 
		required this.premiBiRsmdcc, required this.premiBiTsfwd, 
		required this.premiEqvet, required this.premiNet, 
		required this.premiNonBi, required this.premiOther, 
		required this.premiPar, required this.premiRsmdcc, 
		required this.premiTotal, required this.premiTsfwd, 
		required this.rateEqvet, required this.rateOther, 
		required this.ratePar, required this.rateRsmdcc, 
		required this.rateTotal, required this.rateTsfwd, 
		required this.rkonstruksiojkId, required this.rmatauangKode, 
		required this.rokupasiId, required this.siBi, 
		required this.siBuilding, required this.siContent, 
		required this.siMachinery, required this.siOther, 
		required this.siStock, required this.simulpar1Id, 
		required this.stockAdjustable, required this.theinsured, 
		required this.kabupaten, required this.kelasNama, 
		required this.keterangan, required this.kriteria, 
		required this.okupasiDesc, required this.rMATAUANGNAMA, 
		required this.wilayahNama});

	factory SimulparListModel.fromJson(Map<String, dynamic> data) {
		return SimulparListModel(
			biIndexRate: double.tryParse(data['biIndexRate'].toString())??0,
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			discNilai: double.tryParse(data['discNilai'].toString())??0,
			discPersen: double.tryParse(data['discPersen'].toString())??0,
			kab2zonagempaId: data['kab2zonagempaId']??'',
			mbiindemnityojkId: data['mbiindemnityojkId']??'',
			mtarifojkbanjirparId: data['mtarifojkbanjirparId']??'',
			mwilayahId: data['mwilayahId']??'',
			premiBi: double.tryParse(data['premiBi'].toString())??0,
			premiBiEqvet: double.tryParse(data['premiBiEqvet'].toString())??0,
			premiBiOther: double.tryParse(data['premiBiOther'].toString())??0,
			premiBiPar: double.tryParse(data['premiBiPar'].toString())??0,
			premiBiRsmdcc: double.tryParse(data['premiBiRsmdcc'].toString())??0,
			premiBiTsfwd: double.tryParse(data['premiBiTsfwd'].toString())??0,
			premiEqvet: double.tryParse(data['premiEqvet'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiNonBi: double.tryParse(data['premiNonBi'].toString())??0,
			premiOther: double.tryParse(data['premiOther'].toString())??0,
			premiPar: double.tryParse(data['premiPar'].toString())??0,
			premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,
			premiTsfwd: double.tryParse(data['premiTsfwd'].toString())??0,
			rateEqvet: double.tryParse(data['rateEqvet'].toString())??0,
			rateOther: double.tryParse(data['rateOther'].toString())??0,
			ratePar: double.tryParse(data['ratePar'].toString())??0,
			rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString())??0,
			rateTotal: double.tryParse(data['rateTotal'].toString())??0,
			rateTsfwd: double.tryParse(data['rateTsfwd'].toString())??0,
			rkonstruksiojkId: data['rkonstruksiojkId']??'',
			rmatauangKode: data['rmatauangKode']??'',
			rokupasiId: data['rokupasiId']??'',
			siBi: double.tryParse(data['siBi'].toString())??0,
			siBuilding: double.tryParse(data['siBuilding'].toString())??0,
			siContent: double.tryParse(data['siContent'].toString())??0,
			siMachinery: double.tryParse(data['siMachinery'].toString())??0,
			siOther: double.tryParse(data['siOther'].toString())??0,
			siStock: double.tryParse(data['siStock'].toString())??0,
			simulpar1Id: data['simulpar1Id']??'',
			stockAdjustable: double.tryParse(data['stockAdjustable'].toString())??0,
			theinsured: data['theinsured']??'',
			kabupaten: data['kabupaten']??'',
			kelasNama: data['kelasNama']??'',
			keterangan: data['keterangan']??'',
			kriteria: data['kriteria']??'',
			okupasiDesc: data['okupasiDesc']??'',
			rMATAUANGNAMA: data['rMATAUANGNAMA']??'',
			wilayahNama: data['wilayahNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'biIndexRate': biIndexRate.toString(),
		'coverBulan': coverBulan.toString(),
		'discNilai': discNilai.toString(),
		'discPersen': discPersen.toString(),
		'kab2zonagempaId': kab2zonagempaId,
		'mbiindemnityojkId': mbiindemnityojkId,
		'mtarifojkbanjirparId': mtarifojkbanjirparId,
		'mwilayahId': mwilayahId,
		'premiBi': premiBi.toString(),
		'premiBiEqvet': premiBiEqvet.toString(),
		'premiBiOther': premiBiOther.toString(),
		'premiBiPar': premiBiPar.toString(),
		'premiBiRsmdcc': premiBiRsmdcc.toString(),
		'premiBiTsfwd': premiBiTsfwd.toString(),
		'premiEqvet': premiEqvet.toString(),
		'premiNet': premiNet.toString(),
		'premiNonBi': premiNonBi.toString(),
		'premiOther': premiOther.toString(),
		'premiPar': premiPar.toString(),
		'premiRsmdcc': premiRsmdcc.toString(),
		'premiTotal': premiTotal.toString(),
		'premiTsfwd': premiTsfwd.toString(),
		'rateEqvet': rateEqvet.toString(),
		'rateOther': rateOther.toString(),
		'ratePar': ratePar.toString(),
		'rateRsmdcc': rateRsmdcc.toString(),
		'rateTotal': rateTotal.toString(),
		'rateTsfwd': rateTsfwd.toString(),
		'rkonstruksiojkId': rkonstruksiojkId,
		'rmatauangKode': rmatauangKode,
		'rokupasiId': rokupasiId,
		'siBi': siBi.toString(),
		'siBuilding': siBuilding.toString(),
		'siContent': siContent.toString(),
		'siMachinery': siMachinery.toString(),
		'siOther': siOther.toString(),
		'siStock': siStock.toString(),
		'simulpar1Id': simulpar1Id,
		'stockAdjustable': stockAdjustable.toString(),
		'theinsured': theinsured,
		'kabupaten': kabupaten,
		'kelasNama': kelasNama,
		'keterangan': keterangan,
		'kriteria': kriteria,
		'okupasiDesc': okupasiDesc,
		'rMATAUANGNAMA': rMATAUANGNAMA,
		'wilayahNama': wilayahNama};

}
