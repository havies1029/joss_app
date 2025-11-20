import 'dart:typed_data';
import 'dart:convert';
import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/gen_regmv/regmv5form_api.dart';

class Regmv5FormRepository {
	final Regmv5FormAPI api = Regmv5FormAPI();

	// ----------------------------------------------------
	// DELETE
	// ----------------------------------------------------
	Future<bool> regmv5FormHapus(String regmv5Id) async {
		return await api.regmv5FormHapusAPI(regmv5Id);
	}

	// ----------------------------------------------------
	// UPLOAD FILE PATH (camera)
	// ----------------------------------------------------
	Future<ReturnDataAPI> uploadFileFotoMobil(
			String regmv1Id,
			String filePath,
			) async {
		final raw = await api.uploadFileFotoMobil(regmv1Id, filePath);

		// raw hanya return 'success = true/false'
		// tapi kita tetap wrap ke ReturnDataAPI
		return ReturnDataAPI(
			success: raw.success,
			data: raw.data ?? "",
			rowcount: raw.rowcount ?? 0,
		);
	}

	// ----------------------------------------------------
	// UPLOAD BINARY
	// ----------------------------------------------------
	Future<ReturnDataAPI> uploadBinaryFotoMobil(
			String regmv1Id,
			String fileName,
			Uint8List bytes,
			) async {
		final rawResult = await api.uploadBinaryFotoMobil(regmv1Id, fileName, bytes);

		// API ASP.NET hanya return "Successfully Uploaded: xxx"
		// Jadi rawResult.success hanya mencerminkan statusCode
		return ReturnDataAPI(
			success: rawResult.success,
			data: rawResult.success ? "OK" : "FAILED",
			rowcount: rawResult.success ? 1 : 0,
		);
	}

	// ----------------------------------------------------
	// DOWNLOAD BASE64
	// ----------------------------------------------------
	Future<DownloadFileInfo64Model?> downloadFotoMobilAPI(
			String regmv5Id,
			) async {
		return await api.downloadFotoMobilAPI(regmv5Id);
	}
}
