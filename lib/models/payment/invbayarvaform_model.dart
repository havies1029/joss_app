import 'package:joss_app/models/payment/instruksibayar_model.dart';

class InvbayarvaFormModel {
  String bankNama;
	DateTime batasBayar;
	String iconId;
	String iconUrl;
	String vaNo;
	double totalBayar;
  String curr;
  List<InstruksiBayarModel> instruksi;

	InvbayarvaFormModel({
    required this.bankNama, required this.batasBayar, required this.iconId, 
		required this.iconUrl, required this.vaNo, 
		required this.totalBayar, required this.curr, required this.instruksi,});
	factory InvbayarvaFormModel.fromJson(Map<String, dynamic> data) {
		return InvbayarvaFormModel(
      bankNama: data['bankNama']??'',
			batasBayar: DateTime.tryParse(data['batasBayar'].toString())??DateTime.now(),
			iconId: data['iconId']??'',
			iconUrl: data['iconUrl']??'',
			vaNo: data['vaNo']??'',
			totalBayar: (data['totalBayar'] ?? 0).toDouble(),
      curr: data['curr']??'',
      instruksi: (data['instruksi'] as List<dynamic>?)
          ?.map((e) => InstruksiBayarModel.fromJson(e))
          .toList() ?? [],
		);

	}

	Map<String, dynamic> toJson() =>
		{
      'bankNama': bankNama,
      'batasBayar': batasBayar.toIso8601String(),
      'iconId': iconId,
      'iconUrl': iconUrl,
      'vaNo': vaNo,
      'totalBayar': totalBayar,
      'curr': curr,
      'instruksi': instruksi.map((e) => e.toJson()).toList(),
    };

}
