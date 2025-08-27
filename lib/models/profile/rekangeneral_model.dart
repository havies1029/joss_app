import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/models/combobox/combomtipecst_model.dart';
import 'package:joss_app/models/combobox/combomtitle_model.dart';

class RekanGeneralModel {
	String mrekan1Id;
	String rekanNama;
	String? mbentukcstId;
	ComboMBentukCstModel? comboMBentukCst;
	String? mbidangId;
	ComboMBidangModel? comboMBidang;
	String? mtipecstId;
	ComboMTipeCstModel? comboMTipeCst;
	String? mtitleId;
	ComboMTitleModel? comboMTitle;

	RekanGeneralModel({required this.mrekan1Id, required this.rekanNama, 
		this.mbentukcstId, this.comboMBentukCst, this.mbidangId, this.comboMBidang, 
		this.mtipecstId, this.comboMTipeCst, this.mtitleId, this.comboMTitle});

	factory RekanGeneralModel.fromJson(Map<String, dynamic> data) {
		ComboMBentukCstModel? comboMBentukCst;
		if (data['comboMBentukCst'] != null) {
			comboMBentukCst = ComboMBentukCstModel.fromJson(data['comboMBentukCst']);
		}

		ComboMBidangModel? comboMBidang;
		if (data['comboMBidang'] != null) {
			comboMBidang = ComboMBidangModel.fromJson(data['comboMBidang']);
		}

		ComboMTipeCstModel? comboMTipeCst;
		if (data['comboMTipeCst'] != null) {
			comboMTipeCst = ComboMTipeCstModel.fromJson(data['comboMTipeCst']);
		}

		ComboMTitleModel? comboMTitle;
		if (data['comboMTitle'] != null) {
			comboMTitle = ComboMTitleModel.fromJson(data['comboMTitle']);
		}

		return RekanGeneralModel(
			mrekan1Id: data['mrekan1Id']??'',
			rekanNama: data['rekanNama']??'',
			mbentukcstId: data['mbentukcstId']??'',
			comboMBentukCst: comboMBentukCst,
			mbidangId: data['mbidangId']??'',
			comboMBidang: comboMBidang,
			mtipecstId: data['mtipecstId']??'',
			comboMTipeCst: comboMTipeCst,
			mtitleId: data['mtitleId']??'',
			comboMTitle: comboMTitle
		);

	}

	Map<String, dynamic> toJson() =>
		{'mrekan1Id': mrekan1Id,
		'rekanNama': rekanNama,
		'mbentukcstId': mbentukcstId,
		'comboMBentukCst': comboMBentukCst?.toJson(),
		'mbidangId': mbidangId,
		'comboMBidang': comboMBidang?.toJson(),
		'mtipecstId': mtipecstId,
		'comboMTipeCst': comboMTipeCst?.toJson(),
		'mtitleId': mtitleId,
		'comboMTitle': comboMTitle?.toJson()};

}
