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

		String _asString(dynamic v) => (v ?? '').toString();

		return ComboMMvmodelModel(
			mmvmodelId: _asString(
				data['mmvmodelId'] ?? data['mmvmodel_id'],
			),
			mmvtipeId: _asString(
				data['mmvtipeId'] ??
						data['mvtipeId'] ??      // kalau backend pakai ini
						data['mmvtipe_id'],
			),
			nmModel: _asString(
				data['nmModel'] ?? data['nm_model'],
			),
			nmTipe: _asString(
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
