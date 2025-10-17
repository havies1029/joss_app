
import 'package:string_validator/string_validator.dart';

class RekanPicCobCariModel {
	String mcobId;
	String mrekanpicId;
	String mrekanpiccobId;
	String cobNama;
	bool isChecked = false;

	RekanPicCobCariModel({required this.mcobId, required this.mrekanpicId,
		required this.mrekanpiccobId, required this.cobNama, required this.isChecked});

	factory RekanPicCobCariModel.fromJson(Map<String, dynamic> data) {
		return RekanPicCobCariModel(
				mcobId: data['mcobId']??'',
				mrekanpicId: data['mrekanpicId']??'',
				mrekanpiccobId: data['mrekanpiccobId']??'',
				cobNama: data['cobNama']??'',
				isChecked: toBoolean(data['isChecked'].toString())
		);

	}

	Map<String, dynamic> toJson() =>
			{'mcobId': mcobId,
				'mrekanpicId': mrekanpicId,
				'mrekanpiccobId': mrekanpiccobId,
				'cobNama': cobNama,
				'isChecked': isChecked.toString()};

}

class RekanPicCobCariCheckboxModel {
	String mcobId;
	bool isChecked = false;

	RekanPicCobCariCheckboxModel({required this.mcobId, required this.isChecked});

	factory RekanPicCobCariCheckboxModel.fromJson(Map<String, dynamic> data) {
		return RekanPicCobCariCheckboxModel(
				mcobId: data['mcobId'] ?? '',
				isChecked: toBoolean(data['isChecked'].toString())
		);
	}

	Map<String, dynamic> toJson() =>
			{'mcobId': mcobId, 'isChecked': isChecked.toString()};
}

extension RekanPicCobCariCopy on RekanPicCobCariModel {
	RekanPicCobCariModel copyWith({
		String? mcobId,
		String? mrekanpicId,
		String? mrekanpiccobId,
		String? cobNama,
		bool? isChecked,
	}) {
		return RekanPicCobCariModel(
			mcobId: mcobId ?? this.mcobId,
			mrekanpicId: mrekanpicId ?? this.mrekanpicId,
			mrekanpiccobId: mrekanpiccobId ?? this.mrekanpiccobId,
			cobNama: cobNama ?? this.cobNama,
			isChecked: isChecked ?? this.isChecked,
		);
	}
}
