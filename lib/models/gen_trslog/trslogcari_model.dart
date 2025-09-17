
class TrslogCariModel {
	String keterangan;
	String mjnstrsId;
	String mststrsId;
	double nilaiTrs;
	String trsNoref;
	DateTime trsTgl;
	String trslogId;
	String curr;
	String jenis_trs;
	String status_nama;

	TrslogCariModel({required this.keterangan, 
		required this.mjnstrsId, required this.mststrsId, 
		required this.nilaiTrs, required this.trsNoref, 
		required this.trsTgl, required this.trslogId, 
		required this.curr, required this.jenis_trs, required this.status_nama });

	factory TrslogCariModel.fromJson(Map<String, dynamic> data) {
		return TrslogCariModel(
			keterangan: data['keterangan']??'',
			mjnstrsId: data['mjnstrsId']??'',
			mststrsId: data['mststrsId']??'',
			nilaiTrs: double.tryParse(data['nilaiTrs'].toString())??0,
			trsNoref: data['trsNoref']??'',
			trsTgl: DateTime.tryParse(data['trsTgl'].toString())??DateTime.now(),
			trslogId: data['trslogId']??'',
			curr: data['curr']??'',
      jenis_trs: data['jenis_trs']??'',
      status_nama: data['status_nama']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'keterangan': keterangan,
		'mjnstrsId': mjnstrsId,
		'mststrsId': mststrsId,
		'nilaiTrs': nilaiTrs.toString(),
		'trsNoref': trsNoref,
		'trsTgl': trsTgl.toIso8601String(),
		'trslogId': trslogId,
		'curr': curr,
    'jenis_trs': jenis_trs,
    'status_nama': status_nama
    };

}
