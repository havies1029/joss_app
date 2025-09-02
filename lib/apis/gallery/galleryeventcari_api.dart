import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gallery/galleryeventcari_model.dart';

class GalleryeventCariAPI{
	Future<List<GalleryeventCariModel>> getGalleryeventCariAPI() async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/galeri/galleryeventcari/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos'
		});
   
		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<GalleryeventCariModel>((json) => GalleryeventCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
