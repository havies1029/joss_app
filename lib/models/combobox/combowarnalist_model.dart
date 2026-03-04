import 'package:equatable/equatable.dart';

class ComboWarnaListModel extends Equatable {
	final String mwarnaId;
	final String warnaDesc;
	final String migrasiId;
	final String idTpi;

	const ComboWarnaListModel({this.mwarnaId='', this.warnaDesc='', this.migrasiId='', this.idTpi=''});

	factory ComboWarnaListModel.fromJson(Map<String, dynamic> data) =>
		ComboWarnaListModel(
			mwarnaId: data['mwarnaId'],
			warnaDesc: data['warnaDesc'],
			migrasiId: data['migrasiId'],
			idTpi: data['idTpi']
		);

	Map<String, dynamic> toJson() =>
		{'mwarnaId': mwarnaId,
		'warnaDesc': warnaDesc,
		'migrasiId': migrasiId,
		'idTpi': idTpi};

	@override
	List<Object> get props => [mwarnaId, warnaDesc, migrasiId, idTpi];
}
