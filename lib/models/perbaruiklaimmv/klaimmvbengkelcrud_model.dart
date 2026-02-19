import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';

class KlaimmvbengkelcrudModel {
	String klaim1Id;
	String namaBengkelLain;
	String? mbengkelId;
	ComboMBengkelModel? comboMBengkel;
	String? mjnsbengkelId;
	ComboMJnsbengkelModel? comboMJnsbengkel;
	String? mwilayahbengkelId;
	ComboMWilayahBengkelModel? comboMWilayahBengkel;

	KlaimmvbengkelcrudModel({required this.klaim1Id, required this.namaBengkelLain, 
		this.mbengkelId, this.comboMBengkel, this.mjnsbengkelId, this.comboMJnsbengkel, 
		this.mwilayahbengkelId, this.comboMWilayahBengkel});

	factory KlaimmvbengkelcrudModel.fromJson(Map<String, dynamic> data) {
		ComboMBengkelModel? comboMBengkel;
		if (data['comboMBengkel'] != null) {
			comboMBengkel = ComboMBengkelModel.fromJson(data['comboMBengkel']);
		}

		ComboMJnsbengkelModel? comboMJnsbengkel;
		if (data['comboMJnsbengkel'] != null) {
			comboMJnsbengkel = ComboMJnsbengkelModel.fromJson(data['comboMJnsbengkel']);
		}

		ComboMWilayahBengkelModel? comboMWilayahBengkel;
		if (data['comboMWilayahBengkel'] != null) {
			comboMWilayahBengkel = ComboMWilayahBengkelModel.fromJson(data['comboMWilayahBengkel']);
		}

		return KlaimmvbengkelcrudModel(
			klaim1Id: data['klaim1Id']??'',
			namaBengkelLain: data['namaBengkelLain']??'',
			mbengkelId: data['mbengkelId']??'',
			comboMBengkel: comboMBengkel,
			mjnsbengkelId: data['mjnsbengkelId']??'',
			comboMJnsbengkel: comboMJnsbengkel,
			mwilayahbengkelId: data['mwilayahbengkelId']??'',
			comboMWilayahBengkel: comboMWilayahBengkel
		);

	}

	Map<String, dynamic> toJson() =>
		{'klaim1Id': klaim1Id,
		'namaBengkelLain': namaBengkelLain,
		'mbengkelId': mbengkelId,
		'comboMBengkel': comboMBengkel?.toJson(),
		'mjnsbengkelId': mjnsbengkelId,
		'comboMJnsbengkel': comboMJnsbengkel?.toJson(),
		'mwilayahbengkelId': mwilayahbengkelId,
		'comboMWilayahBengkel': comboMWilayahBengkel?.toJson()};

  
  KlaimmvbengkelcrudModel copyWith({
    String? klaim1Id,
    String? namaBengkelLain,
    String? mbengkelId,
    ComboMBengkelModel? comboMBengkel,
    String? mjnsbengkelId,
    ComboMJnsbengkelModel? comboMJnsbengkel,
    String? mwilayahbengkelId,
    ComboMWilayahBengkelModel? comboMWilayahBengkel,
  }) {
    return KlaimmvbengkelcrudModel(
      klaim1Id: klaim1Id ?? this.klaim1Id,
      namaBengkelLain: namaBengkelLain ?? this.namaBengkelLain,
      mbengkelId: mbengkelId ?? this.mbengkelId,
      comboMBengkel: comboMBengkel ?? this.comboMBengkel,
      mjnsbengkelId: mjnsbengkelId ?? this.mjnsbengkelId,
      comboMJnsbengkel: comboMJnsbengkel ?? this.comboMJnsbengkel,
      mwilayahbengkelId: mwilayahbengkelId ?? this.mwilayahbengkelId,
      comboMWilayahBengkel: comboMWilayahBengkel ?? this.comboMWilayahBengkel,
    );
  }

factory KlaimmvbengkelcrudModel.empty() {
  return KlaimmvbengkelcrudModel(
    klaim1Id: '',
    namaBengkelLain: '',
    mbengkelId: null, 
    comboMBengkel: null,
    mjnsbengkelId: null,
    comboMJnsbengkel: null,
    mwilayahbengkelId: null,
    comboMWilayahBengkel: null,
  );
}


}
