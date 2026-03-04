import 'package:equatable/equatable.dart';

class ComboMvtipeListModel extends Equatable {
	final String mmvtipeId;
	final String nmTipe;
	final String mvmerkId;
	final String migrasiId;
	final String refDepkeuId;
	final String jenisId;
	final String dataFrom;
	final String nmMerk;

	const ComboMvtipeListModel({this.mmvtipeId='', this.nmTipe='', this.mvmerkId='', this.migrasiId='', this.refDepkeuId='', this.jenisId='', this.dataFrom='', this.nmMerk=''});

	factory ComboMvtipeListModel.fromJson(Map<String, dynamic> data) =>
		ComboMvtipeListModel(
			mmvtipeId: data['mmvtipeId'],
			nmTipe: data['nmTipe'],
			mvmerkId: data['mvmerkId'],
			migrasiId: data['migrasiId'],
			refDepkeuId: data['refDepkeuId'],
			jenisId: data['jenisId'],
			dataFrom: data['dataFrom'],
			nmMerk: data['nmMerk']
		);

	Map<String, dynamic> toJson() =>
		{'mmvtipeId': mmvtipeId,
		'nmTipe': nmTipe,
		'mvmerkId': mvmerkId,
		'migrasiId': migrasiId,
		'refDepkeuId': refDepkeuId,
		'jenisId': jenisId,
		'dataFrom': dataFrom,
		'nmMerk': nmMerk};

	@override
	List<Object> get props => [mmvtipeId, nmTipe, mvmerkId, migrasiId, refDepkeuId, jenisId, dataFrom, nmMerk];
}
