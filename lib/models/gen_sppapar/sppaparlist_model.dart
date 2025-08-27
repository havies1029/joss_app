
class SppaparListModel {
	String insuredAlamat1;
	String insuredAlamat2;
	String insuredNama;
	String lokasi1;
	String lokasi2;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	double premiTotal;
	DateTime sppaTgl;
	String sppa1Id;
	double tsi;
	String kabupaten;
	String kelasNama;
	String kODEPOSNO;
	String kriteria;
	String okupasiDesc;
	String curr;
	String wilayahNama;

	SppaparListModel({
		required this.insuredAlamat1, required this.insuredAlamat2, 
    required this.insuredNama, required this.lokasi1, 
		required this.lokasi2, required this.periodeAkhir, 
		required this.periodeMulai, required this.premiTotal, 
		required this.sppaTgl, required this.sppa1Id, 		
		required this.tsi, required this.kabupaten, 
    required this.kelasNama, required this.kODEPOSNO, 
		required this.kriteria, required this.okupasiDesc, 
		required this.curr, required this.wilayahNama});

	factory SppaparListModel.fromJson(Map<String, dynamic> data) {
		return SppaparListModel(			
			insuredAlamat1: data['insuredAlamat1']??'',
			insuredAlamat2: data['insuredAlamat2']??'',
			insuredNama: data['insuredNama']??'',			
			lokasi1: data['lokasi1']??'',
			lokasi2: data['lokasi2']??'',			
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),			
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,			
			sppaTgl: DateTime.tryParse(data['sppaTgl'].toString())??DateTime.now(),
			sppa1Id: data['sppa1Id']??'',			
			tsi: double.tryParse(data['tsi'].toString())??0,			
			kabupaten: data['kabupaten']??'',
			kelasNama: data['kelasNama']??'',			
			kODEPOSNO: data['kODEPOSNO']??'',
			kriteria: data['kriteria']??'',
			okupasiDesc: data['okupasiDesc']??'',
			curr: data['curr']??'',
			wilayahNama: data['wilayahNama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{
      
		'insuredAlamat1': insuredAlamat1,
		'insuredAlamat2': insuredAlamat2,
		'insuredNama': insuredNama,
		'lokasi1': lokasi1,
		'lokasi2': lokasi2,		
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),		
		'premiTotal': premiTotal.toString(),		
		'sppaTgl': sppaTgl.toIso8601String(),
		'sppa1Id': sppa1Id,		
		'tsi': tsi.toString(),		
		'kabupaten': kabupaten,
		'kelasNama': kelasNama,		
		'kODEPOSNO': kODEPOSNO,
		'kriteria': kriteria,
		'okupasiDesc': okupasiDesc,
		'curr': curr,
		'wilayahNama': wilayahNama};

}
