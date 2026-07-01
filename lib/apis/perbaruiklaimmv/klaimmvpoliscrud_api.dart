//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvpoliscrud_model.dart';

class KlaimmvpoliscrudAPI {
	Map<String, String> get _headers => <String, String>{
		'Content-Type': 'application/json; odata=verbos',
		'Accept': 'application/json; odata=verbos',
		'Authorization': 'Bearer ${AppData.userToken}',
	};

	void _debugRequest({
		required String methodName,
		required String httpMethod,
		required Uri uri,
		Object? body,
		Map<String, String>? params,
	}) {
		debugPrint("========== $methodName REQUEST ==========");
		debugPrint("METHOD : $httpMethod");
		debugPrint("URL    : $uri");

		if (params != null && params.isNotEmpty) {
			debugPrint("PARAMS : $params");
		}

		debugPrint("HEADERS:");
		_headers.forEach((key, value) {
			debugPrint("$key : $value");
		});

		if (body != null) {
			debugPrint("BODY   : ${jsonEncode(body)}");
		}

		debugPrint("=========================================");
	}

	void _debugResponse({
		required String methodName,
		required http.Response response,
	}) {
		debugPrint("========== $methodName RESPONSE ==========");
		debugPrint("STATUS : ${response.statusCode}");
		debugPrint("BODY   : ${response.body}");
		debugPrint("==========================================");
	}

	void _debugReturnData({
		required String methodName,
		required ReturnDataAPI returnData,
	}) {
		debugPrint("========== $methodName RETURN DATA ==========");
		debugPrint("SUCCESS  : ${returnData.success}");
		debugPrint("DATA     : ${returnData.data}");
		debugPrint("ROWCOUNT : ${returnData.rowcount}");
		debugPrint("=============================================");
	}

	void _debugError({
		required String methodName,
		required Object error,
		StackTrace? stackTrace,
	}) {
		debugPrint("========== $methodName ERROR ==========");
		debugPrint("ERROR : $error");

		if (stackTrace != null) {
			debugPrint("STACKTRACE : $stackTrace");
		}

		debugPrint("=======================================");
	}

	ReturnDataAPI _parseReturnData({
		required String methodName,
		required http.Response response,
	}) {
		if (response.statusCode == 200) {
			final returnData =
			ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));

			_debugReturnData(
				methodName: methodName,
				returnData: returnData,
			);

			return returnData;
		}

		debugPrint("========== $methodName HTTP ERROR ==========");
		debugPrint("STATUS : ${response.statusCode}");
		debugPrint("BODY   : ${response.body}");
		debugPrint("============================================");

		return ReturnDataAPI(
			success: false,
			data: "",
			rowcount: 0,
		);
	}

	Future<ReturnDataAPI> klaimmvpoliscrudTambahAPI(
			KlaimmvpoliscrudModel record) async {
		const String methodName = "klaimmvpoliscrudTambahAPI";

		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/create";

		Map<String, String> queryParams = {
			"modul_id": methodName,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			tambahEndpoint,
			queryParams,
		);

		final body = record.toJson();

		_debugRequest(
			methodName: methodName,
			httpMethod: "POST",
			uri: uri,
			params: queryParams,
			body: body,
		);

		try {
			final http.Response response = await http.post(
				uri,
				headers: _headers,
				body: jsonEncode(body),
			);

			_debugResponse(
				methodName: methodName,
				response: response,
			);

			return _parseReturnData(
				methodName: methodName,
				response: response,
			);
		} catch (e, stackTrace) {
			_debugError(
				methodName: methodName,
				error: e,
				stackTrace: stackTrace,
			);
			rethrow;
		}
	}

	Future<bool> klaimmvpoliscrudUbahAPI(
			KlaimmvpoliscrudModel record) async {
		const String methodName = "klaimmvpoliscrudUbahAPI";

		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/update";

		Map<String, String> queryParams = {
			"modul_id": methodName,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			ubahEndpoint,
			queryParams,
		);

		final body = record.toJson();

		_debugRequest(
			methodName: methodName,
			httpMethod: "POST",
			uri: uri,
			params: queryParams,
			body: body,
		);

		try {
			final http.Response response = await http.post(
				uri,
				headers: _headers,
				body: jsonEncode(body),
			);

			_debugResponse(
				methodName: methodName,
				response: response,
			);

			final returnData = _parseReturnData(
				methodName: methodName,
				response: response,
			);

			return returnData.success;
		} catch (e, stackTrace) {
			_debugError(
				methodName: methodName,
				error: e,
				stackTrace: stackTrace,
			);
			rethrow;
		}
	}

	Future<bool> klaimmvpoliscrudHapusAPI(String klaim1Id) async {
		const String methodName = "klaimmvpoliscrudHapusAPI";

		String hapusEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/delete";

		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
			'modul_id': methodName,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			hapusEndpoint,
			queryParams,
		);

		_debugRequest(
			methodName: methodName,
			httpMethod: "GET",
			uri: uri,
			params: queryParams,
		);

		try {
			final http.Response response = await http.get(
				uri,
				headers: _headers,
			);

			_debugResponse(
				methodName: methodName,
				response: response,
			);

			final returnData = _parseReturnData(
				methodName: methodName,
				response: response,
			);

			return returnData.success;
		} catch (e, stackTrace) {
			_debugError(
				methodName: methodName,
				error: e,
				stackTrace: stackTrace,
			);
			rethrow;
		}
	}

	Future<KlaimmvpoliscrudModel?> klaimmvpoliscrudLihatAPI(
			String klaim1Id) async {
		const String methodName = "klaimmvpoliscrudLihatAPI";

		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/read";

		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			lihatEndpoint,
			queryParams,
		);

		_debugRequest(
			methodName: methodName,
			httpMethod: "GET",
			uri: uri,
			params: queryParams,
		);

		try {
			final http.Response response = await http.get(
				uri,
				headers: _headers,
			);

			_debugResponse(
				methodName: methodName,
				response: response,
			);

			if (response.statusCode == 200) {
				final data = KlaimmvpoliscrudModel.fromJson(
					jsonDecode(response.body),
				);

				debugPrint("========== $methodName READ SUCCESS ==========");
				debugPrint("DATA : ${response.body}");
				debugPrint("==============================================");

				return data;
			}

			if (response.statusCode == 404) {
				debugPrint("========== $methodName NOT FOUND ==========");
				debugPrint("klaim1Id : $klaim1Id");
				debugPrint("===========================================");
				return null;
			}

			throw HttpException(
				'HTTP ${response.statusCode}: ${response.body}',
			);
		} catch (e, stackTrace) {
			_debugError(
				methodName: methodName,
				error: e,
				stackTrace: stackTrace,
			);

			throw Exception("Failed to load data: $e");
		}
	}
}