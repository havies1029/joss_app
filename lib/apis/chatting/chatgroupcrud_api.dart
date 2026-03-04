import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/chatting/groupchat_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGroupCrudAPI {
  String urlGetListEndPoint =
      "${AppData.prefixEndPoint}/api/groupchat/chatcari/getlist";
  final String _base = AppData.apiDomain;
  final _addTextMessageGroupChatEndpoint = "api/groupchat/textmessage/tambah";
  final _addAttachmentGroupChatEndpoint = "api/groupchat/attachment/tambah";

  Future<String> getChatgroupCariAPI(String roomId, int hal) async {
    Map<String, String> queryParams = {"roomId": roomId, "hal": hal.toString()};

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
    
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    //debugPrint("response.body : ${response.body}");

    return response.body;
  }

  Future<ReturnDataAPI> addTextMessageGroupChatAPI(
      GroupchatModel chatmsg) async {
    ReturnDataAPI returnData;

    String addGroupChatURL = _base + _addTextMessageGroupChatEndpoint;

    //debugPrint("addGroupChatAPI");
    //debugPrint(addGroupChatURL);

    final http.Response response = await http.post(Uri.parse(addGroupChatURL),
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
        body: jsonEncode(chatmsg.toJson()));

    //debugPrint("response.statusCode : ${response.statusCode}");
    //debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }

    return returnData;
  }

  Future<ReturnDataAPI> addAttachmentGroupChatAPI(
      GroupchatModel chatmsg) async {
    ReturnDataAPI returnData =
        ReturnDataAPI(success: false, data: "", rowcount: 0);

    String addAttachmentGroupChatURL = _base + _addAttachmentGroupChatEndpoint;

    //debugPrint("addAttachmentGroupChatAPI");
    //debugPrint(addAttachmentGroupChatURL);

    var request =
        http.MultipartRequest('POST', Uri.parse(addAttachmentGroupChatURL));

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    request.headers.addAll(headers);
    request.files
        .add(await http.MultipartFile.fromPath('image_file', chatmsg.uri!));
    request.fields['chatmsg'] = jsonEncode(chatmsg.toJson());

    await request.send().then((response) {
      if (response.statusCode == 200) {
        debugPrint("Success send Image");
        /*
        response.stream.transform(utf8.decoder).listen((value) {
          debugPrint(value);
        });
        */
        //returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.));
      } else {
        debugPrint("Error send Image");
      }
    });
    return returnData;
  }
}
