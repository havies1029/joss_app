
class ReqComproModel {
	DateTime regTgl;
	String sendTo;

	ReqComproModel({required this.regTgl, required this.sendTo});

	factory ReqComproModel.fromJson(Map<String, dynamic> data) {
		return ReqComproModel(			
			regTgl: DateTime.tryParse(data['regTgl'].toString())??DateTime.now(),			
			sendTo: data['sendTo']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'regTgl': regTgl.toIso8601String(),		
		'sendTo': sendTo};
}
