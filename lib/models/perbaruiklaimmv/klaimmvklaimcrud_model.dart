import 'package:joss_app/models/combobox/combormatauang_model.dart';

class KlaimmvklaimcrudModel {
	DateTime? dol;
	double? klaimAmount;
	double? klaimBayar;
	String? klaim1Id;
	String? kronologis;
	String? currId;
	String? mjenisrugimvId;
	ComboRMatauangModel? comboRMatauang;

	KlaimmvklaimcrudModel({
		this.dol,
		this.klaimAmount,
		this.klaimBayar,
		this.klaim1Id,
		this.kronologis,
		this.currId,
		this.mjenisrugimvId,
		this.comboRMatauang,
	});

	factory KlaimmvklaimcrudModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang =
					ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return KlaimmvklaimcrudModel(
			dol: data['dol'] == null || data['dol'].toString().isEmpty
					? null
					: DateTime.tryParse(data['dol'].toString()),
			klaimAmount: double.tryParse(data['klaimAmount']?.toString() ?? ''),
			klaimBayar: double.tryParse(data['klaimBayar']?.toString() ?? ''),
			klaim1Id: data['klaim1Id'],
			kronologis: data['kronologis'],
			currId: data['currId'],
			mjenisrugimvId: data['mjenisrugimvId'],
			comboRMatauang: comboRMatauang,
		);
	}

	Map<String, dynamic> toJson() => {
		'dol': dol?.toIso8601String(),
		'klaimAmount': klaimAmount ?? 0,
		'klaimBayar': klaimBayar ?? 0,
		'klaim1Id': klaim1Id ?? '',
		'kronologis': kronologis ?? '',
		'currId': currId ?? '',
		'mjenisrugimvId': mjenisrugimvId ?? '',
		'comboRMatauang': comboRMatauang?.toJson(),
	};

	KlaimmvklaimcrudModel copyWith({
		DateTime? dol,
		double? klaimAmount,
		double? klaimBayar,
		String? klaim1Id,
		String? kronologis,
		String? currId,
		String? mjenisrugimvId,
		ComboRMatauangModel? comboRMatauang,
	}) {
		return KlaimmvklaimcrudModel(
			dol: dol ?? this.dol,
			klaimAmount: klaimAmount ?? this.klaimAmount,
			klaimBayar: klaimBayar ?? this.klaimBayar,
			klaim1Id: klaim1Id ?? this.klaim1Id,
			kronologis: kronologis ?? this.kronologis,
			currId: currId ?? this.currId,
			mjenisrugimvId: mjenisrugimvId ?? this.mjenisrugimvId,
			comboRMatauang: comboRMatauang ?? this.comboRMatauang,
		);
	}

	factory KlaimmvklaimcrudModel.empty() {
		return KlaimmvklaimcrudModel(
			dol: null,
			klaimAmount: null,
			klaimBayar: null,
			klaim1Id: '',
			kronologis: '',
			currId: '',
			mjenisrugimvId: '',
			comboRMatauang: null,
		);
	}
}