import 'package:equatable/equatable.dart';

class ComboMMvmodelModel extends Equatable {
	final String mmvmodelId;
	final String mmvtipeId;
	final String nmModel;
	final String nmTipe;

	const ComboMMvmodelModel({
		this.mmvmodelId = '',
		this.mmvtipeId = '',
		this.nmModel = '',
		this.nmTipe = '',
	});

	factory ComboMMvmodelModel.fromJson(Map<String, dynamic> data) {
		// debug optional
		// debugPrint('[ComboMMvmodelModel.fromJson] raw: $data');

		String asString(dynamic v) => (v ?? '').toString();

		return ComboMMvmodelModel(
			mmvmodelId: asString(
				data['mmvmodelId'] ?? data['mmvmodel_id'],
			),
			mmvtipeId: asString(
				data['mmvtipeId'] ??
						data['mvtipeId'] ??      // kalau backend pakai ini
						data['mmvtipe_id'],
			),
			nmModel: asString(
				data['nmModel'] ?? data['nm_model'],
			),
			nmTipe: asString(
				data['nmTipe'] ?? data['nm_tipe'], // mungkin ada join ke tipe
			),
		);
	}

	Map<String, dynamic> toJson() => {
		'mmvmodelId': mmvmodelId,
		'mmvtipeId': mmvtipeId,
		'nmModel': nmModel,
		'nmTipe': nmTipe,
	};

	@override
	List<Object> get props => [mmvmodelId, mmvtipeId, nmModel, nmTipe];
}
