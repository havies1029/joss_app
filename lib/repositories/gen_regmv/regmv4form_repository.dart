import 'dart:typed_data';

import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv4form_api.dart';

class Regmv4FormRepository {
	Regmv4FormAPI api = Regmv4FormAPI();

	Future<ReturnDataAPI> uploadFileFotoSTNK(
			String regmv1Id,
			String filePath,
			) async {
		return await api.uploadFileFotoSTNK(regmv1Id, filePath);
	}

	Future<ReturnDataAPI> uploadBinaryFotoSTNK(
			String regmv1Id,
			String fileName,
			Uint8List bytes,
			) async {
		return await api.uploadBinaryFotoSTNK(regmv1Id, fileName, bytes);
	}

	Future<DownloadFileInfo64Model?> downloadFotoStnkAPI(
			String regmv4Id,
			) async {
		return await api.downloadFotoStnkAPI(regmv4Id);
	}

	Future<bool> regmv4FormHapus(String regmv4Id) async {
		return await api.regmv4FormHapusAPI(regmv4Id);
	}
}
