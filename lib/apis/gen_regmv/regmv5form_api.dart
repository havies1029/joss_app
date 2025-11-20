import 'dart:convert';
import 'dart:typed_data';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class Regmv5FormAPI {

	// --------------------------------------------------------
	// UPLOAD FILE DARI PATH (Camera)
	// --------------------------------------------------------
	Future<ReturnDataAPI> uploadFileFotoMobil(
			String regmv1Id,
			String filePath,
			) async {

		final String url = "${AppData.apiDomain}/api/regmv/regmv5form/uploadfilefotomobil";
		final request = http.MultipartRequest("POST", Uri.parse(url));

		request.headers.addAll(AppData.httpHeaders);
		request.fields["regmv1Id"] = regmv1Id;

		request.files.add(
			await http.MultipartFile.fromPath("image_file", filePath),
		);

		final streamed = await request.send();
		final body = await streamed.stream.bytesToString();

		debugPrint("[API][UPLOAD_FILE] status=${streamed.statusCode}, body=$body");

		final ok = streamed.statusCode == 200;

		return ReturnDataAPI(
			success: ok,
			data: ok ? "OK" : "FAILED",
			rowcount: ok ? 1 : 0,
		);
	}

	// --------------------------------------------------------
	// UPLOAD BINARY (Gallery)
	// --------------------------------------------------------
	Future<ReturnDataAPI> uploadBinaryFotoMobil(
			String regmv1Id,
			String fileName,
			Uint8List bytes,
			) async {

		final String url = "${AppData.apiDomain}/api/regmv/regmv5form/uploadbinaryfotomobil";
		final request = http.MultipartRequest("POST", Uri.parse(url));

		request.headers.addAll(AppData.httpHeaders);
		request.fields["regmv1Id"] = regmv1Id;
		request.fields["filename"] = fileName;

		request.files.add(
			http.MultipartFile.fromBytes(
				"image_file",
				bytes,
				filename: fileName,
			),
		);

		final streamed = await request.send();
		final body = await streamed.stream.bytesToString();

		debugPrint("[API][UPLOAD_BINARY] status=${streamed.statusCode}, body=$body");

		final ok = streamed.statusCode == 200;

		return ReturnDataAPI(
			success: ok,
			data: ok ? "OK" : "FAILED",
			rowcount: ok ? 1 : 0,
		);
	}

	// --------------------------------------------------------
	// DOWNLOAD FOTO 64
	// --------------------------------------------------------
	Future<DownloadFileInfo64Model?> downloadFotoMobilAPI(
			String regmv5Id,
			) async {

		final String endpoint = "${AppData.prefixEndPoint}/api/regmv/regmv5form/getfotomobil";

		final uri = AppData.uriHtpp(
			AppData.httpAuthority,
			endpoint,
			{"regmv5Id": regmv5Id},
		);

		final response = await http.get(uri, headers: AppData.httpHeaders);

		debugPrint("[API][DOWNLOAD] status=${response.statusCode}");

		if (response.statusCode != 200) return null;

		return DownloadFileInfo64Model.fromJson(jsonDecode(response.body));
	}

	// --------------------------------------------------------
	// HAPUS
	// --------------------------------------------------------
	Future<bool> regmv5FormHapusAPI(String regmv5Id) async {
		final endpoint = "${AppData.prefixEndPoint}/api/regmv/regmv5form/delete";

		final uri = AppData.uriHtpp(
			AppData.httpAuthority,
			endpoint,
			{
				"regmv5Id": regmv5Id,
				"modul_id": "regmv5FormHapusAPI",
			},
		);

		final response = await http.get(
			uri,
			headers: {
				"Content-Type": "application/json",
				"Accept": "application/json",
				"Authorization": "Bearer ${AppData.userToken}",
			},
		);

		if (response.statusCode != 200) return false;

		final json = jsonDecode(response.body);
		final ret = ReturnDataAPI.fromDatabaseJson(json);

		return ret.success;
	}
}
