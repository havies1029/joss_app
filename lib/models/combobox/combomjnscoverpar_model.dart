import 'package:equatable/equatable.dart';

class ComboMJnscoverParModel extends Equatable {
	final String mjnscoverparId;
	final String jenisNama;
	final bool isFlexas;
	final bool isRsmdcc;
	final bool isTsfwd;
	final bool isEq;
	final bool isOther;

	const ComboMJnscoverParModel({this.mjnscoverparId='', this.jenisNama='', this.isFlexas=false, this.isRsmdcc=false, this.isTsfwd=false, this.isEq=false, this.isOther=false});

	factory ComboMJnscoverParModel.fromJson(Map<String, dynamic> data) =>
			ComboMJnscoverParModel(
					mjnscoverparId: data['mjnscoverparId'],
					jenisNama: data['jenisNama'],
					isFlexas: data['isFlexas'],
					isRsmdcc: data['isRsmdcc'],
					isTsfwd: data['isTsfwd'],
					isEq: data['isEq'],
					isOther: data['isOther']
			);

	Map<String, dynamic> toJson() =>
			{'mjnscoverparId': mjnscoverparId,
				'jenisNama': jenisNama,
				'isFlexas': isFlexas,
				'isRsmdcc': isRsmdcc,
				'isTsfwd': isTsfwd,
				'isEq': isEq,
				'isOther': isOther};

	@override
	List<Object> get props => [mjnscoverparId, jenisNama, isFlexas, isRsmdcc, isTsfwd, isEq, isOther];
}