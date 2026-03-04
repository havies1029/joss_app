
import '../../common/constants.dart';

class Regendors2CariModel {
	String regendors2Id;
	String remarks;
	DateTime? tglStatus;
	String progressNama;

	Regendors2CariModel({
		required this.regendors2Id, required this.remarks,
		required this.tglStatus, required this.progressNama});

	factory Regendors2CariModel.fromJson(Map<String, dynamic> data) {
		return Regendors2CariModel(
			regendors2Id: data['regendors2Id'] ?? '',
			remarks: data['remarks'] ?? '',
			tglStatus: parseDate(data['tglStatus']),
			progressNama: data['progressNama'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'regendors2Id': regendors2Id,
		'remarks': remarks,
		'tglStatus': tglStatus?.toIso8601String(),
		'progressNama': progressNama,
	};
}
