
class LogtrscariModel {
	String jenisLog;
	String keterangan;
	int logId;
	String status;
	DateTime tglDibuat;
	String groupBulan;
  double amount1;
  String curr;
  String remark1;
  String groupLogId;

	LogtrscariModel({required this.jenisLog, 
		required this.keterangan, required this.logId, 
		required this.status, required this.tglDibuat, 
		required this.groupBulan, required this.amount1, 
		required this.curr, required this.remark1, 
		required this.groupLogId});

	factory LogtrscariModel.fromJson(Map<String, dynamic> data) {
		return LogtrscariModel(
			jenisLog: data['jenisLog']??'',
			keterangan: data['keterangan']??'',
			logId: int.tryParse(data['logId'].toString())??0,
			status: data['status']??'',
			tglDibuat: DateTime.tryParse(data['tglDibuat'].toString())??DateTime.now(),
			groupBulan: data['groupBulan']??'',
			amount1: double.tryParse(data['amount1'].toString())??0.0,
			curr: data['curr']??'',
			remark1: data['remark1']??'',
			groupLogId: data['groupLogId']??''
		);
	}

	Map<String, dynamic> toJson() =>
		{'jenisLog': jenisLog,
		'keterangan': keterangan,
		'logId': logId.toString(),
		'status': status,
		'tglDibuat': tglDibuat.toIso8601String(),
		'groupBulan': groupBulan,
		'amount1': amount1,
		'curr': curr,
		'remark1': remark1,
		'groupLogId': groupLogId};

}
