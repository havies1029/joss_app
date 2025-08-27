import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';

class MRekanGeneralCmpCrudModel {
	String? rekanNama;
	String? mbentukcstId;
	ComboMBentukCstModel? comboMBentukCst;
	String? mbidangId;
	ComboMBidangModel? comboMBidang;

	MRekanGeneralCmpCrudModel({ this.rekanNama, this.mbentukcstId, 
    this.comboMBentukCst, this.mbidangId, this.comboMBidang});

	factory MRekanGeneralCmpCrudModel.fromJson(Map<String, dynamic> data) {
		ComboMBentukCstModel? comboMBentukCst;
		if (data['comboMBentukCst'] != null) {
			comboMBentukCst = ComboMBentukCstModel.fromJson(data['comboMBentukCst']);
		}

		ComboMBidangModel? comboMBidang;
		if (data['comboMBidang'] != null) {
			comboMBidang = ComboMBidangModel.fromJson(data['comboMBidang']);
		}

		return MRekanGeneralCmpCrudModel(
			rekanNama: data['rekanNama']??'',
			mbentukcstId: data['mbentukcstId']??'',
			comboMBentukCst: comboMBentukCst,
			mbidangId: data['mbidangId']??'',
			comboMBidang: comboMBidang
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'rekanNama': rekanNama,
		'mbentukcstId': mbentukcstId,
		'comboMBentukCst': comboMBentukCst?.toJson(),
		'mbidangId': mbidangId,
		'comboMBidang': comboMBidang?.toJson()};

}
