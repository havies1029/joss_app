import 'package:joss_app/models/payment/instruksibayar_model.dart';

class InvbayarvaFormModel {
  String bankNama;
	DateTime batasBayar;
	String iconId;
	String iconUrl;
	String vaNo;
	double totalBayar;
  String curr;
  String paymentStatus;
  List<InstruksiBayarModel> instruksi;

	InvbayarvaFormModel({
    required this.bankNama, required this.batasBayar, required this.iconId, 
		required this.iconUrl, required this.vaNo, 
		required this.totalBayar, required this.curr, required this.paymentStatus, required this.instruksi,});

	factory InvbayarvaFormModel.fromJson(Map<String, dynamic> data) {
		return InvbayarvaFormModel(
      bankNama: data['bankNama']??'',
			batasBayar: DateTime.tryParse(data['batasBayar'].toString())??DateTime.now(),
			iconId: data['iconId']??'',
			iconUrl: data['iconUrl']??'',
			vaNo: data['vaNo']??'',
			totalBayar: (data['totalBayar'] ?? 0).toDouble(),
      curr: data['curr']??'',
      paymentStatus: data['paymentStatus']??'',
      instruksi: (data['instruksi'] as List<dynamic>?)
          ?.map((e) => InstruksiBayarModel.fromJson(e))
          .toList() ?? [],
		);

	}

  factory InvbayarvaFormModel.empty() {
    return InvbayarvaFormModel(
      bankNama: '',
      batasBayar: DateTime.now(),
      iconId: '',
      iconUrl: '',
      vaNo: '',
      totalBayar: 0.0,
      curr: '',
      paymentStatus: '',
      instruksi: [],
    );
  }

  InvbayarvaFormModel copyWith({
    String? bankNama,
    DateTime? batasBayar,
    String? iconId,
    String? iconUrl,
    String? vaNo,
    double? totalBayar,
    String? curr,
    String? paymentStatus,
    List<InstruksiBayarModel>? instruksi,
  }) {
    return InvbayarvaFormModel(
      bankNama: bankNama ?? this.bankNama,
      batasBayar: batasBayar ?? this.batasBayar,
      iconId: iconId ?? this.iconId,
      iconUrl: iconUrl ?? this.iconUrl,
      vaNo: vaNo ?? this.vaNo,
      totalBayar: totalBayar ?? this.totalBayar,
      curr: curr ?? this.curr,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      instruksi: instruksi ?? this.instruksi,
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
      'paymentStatus': paymentStatus,
      'instruksi': instruksi.map((e) => e.toJson()).toList(),
    };

}
