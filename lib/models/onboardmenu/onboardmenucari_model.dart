import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class OnBoardMenuCariModel {
  bool clientassignment = false;
  bool policyoutstanding = false;
  bool briefing = false;

  OnBoardMenuCariModel(
      {required this.clientassignment, required this.policyoutstanding, required this.briefing});

  factory OnBoardMenuCariModel.fromJson(Map<String, dynamic> data) {
    debugPrint(
        "toBoolean(data['policyoutstanding'].toString()) : ${toBoolean(data['policyoutstanding'].toString())}");

    return OnBoardMenuCariModel(
        clientassignment: toBoolean(data['clientassignment'].toString()),
        policyoutstanding: toBoolean(data['policyoutstanding'].toString()),
        briefing: toBoolean(data['briefing'].toString()));
  }

  Map<String, dynamic> toJson() => {
        'clientassignment': clientassignment.toString(),
        'policyoutstanding': policyoutstanding.toString(),
        'briefing': briefing.toString()
      };
}
