
class DnFooterCobModel {
	String cobId;
	String currSimbol;
	String dnfootercobId;
	double totalOs;

	DnFooterCobModel({required this.cobId, required this.currSimbol, 
		required this.dnfootercobId, required this.totalOs});

	factory DnFooterCobModel.fromJson(Map<String, dynamic> data) {
		return DnFooterCobModel(
			cobId: data['cobId']??'',
			currSimbol: data['currSimbol']??'',
			dnfootercobId: data['dnfootercobId']??'',
			totalOs: double.tryParse(data['totalOs'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobId': cobId,
		'currSimbol': currSimbol,
		'dnfootercobId': dnfootercobId,
		'totalOs': totalOs.toString()};

}
