import 'package:joss_app/models/combobox/combormatauang_model.dart';

class KlaimmvklaimcrudModel {
	DateTime dol;
	double klaimAmount;
	double klaimBayar;
	String klaim1Id;
	String kronologis;
	String? currId;
	ComboRMatauangModel? comboRMatauang;

	KlaimmvklaimcrudModel({required this.dol, required this.klaimAmount, 
		required this.klaimBayar, required this.klaim1Id, 
		required this.kronologis, this.currId, this.comboRMatauang});

	factory KlaimmvklaimcrudModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return KlaimmvklaimcrudModel(
			dol: DateTime.tryParse(data['dol'].toString())??DateTime.now(),
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaimBayar: double.tryParse(data['klaimBayar'].toString())??0,
			klaim1Id: data['klaim1Id']??'',
			kronologis: data['kronologis']??'',
			currId: data['currId']??'',
			comboRMatauang: comboRMatauang
		);

	}

	Map<String, dynamic> toJson() =>
		{'dol': dol.toIso8601String(),
		'klaimAmount': klaimAmount.toString(),
		'klaimBayar': klaimBayar.toString(),
		'klaim1Id': klaim1Id,
		'kronologis': kronologis,
		'currId': currId,
		'comboRMatauang': comboRMatauang?.toJson()};

  KlaimmvklaimcrudModel copyWith({
    DateTime? dol,
    double? klaimAmount,
    double? klaimBayar,
    String? klaim1Id,
    String? kronologis,
    String? currId,
    ComboRMatauangModel? comboRMatauang,
  }) {
    return KlaimmvklaimcrudModel(
      dol: dol ?? this.dol,
      klaimAmount: klaimAmount ?? this.klaimAmount,
      klaimBayar: klaimBayar ?? this.klaimBayar,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      kronologis: kronologis ?? this.kronologis,
      currId: currId ?? this.currId,
      comboRMatauang: comboRMatauang ?? this.comboRMatauang,
    );
  }

}
