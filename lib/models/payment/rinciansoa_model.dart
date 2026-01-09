import 'dngrandtotal_model.dart';
import 'dnheadercob_model.dart';

class RincianSOAModel {
  final List<DnHeaderCobModel> headers;
  final List<DnGrandTotalModel> grandtotal;

  RincianSOAModel({
    required this.headers,
    required this.grandtotal,
  });

  factory RincianSOAModel.fromJson(Map<String, dynamic> json) {
    return RincianSOAModel(
      headers: (json['headers'] as List<dynamic>? ?? [])
          .map((e) => DnHeaderCobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandtotal: (json['grandtotal'] as List<dynamic>? ?? [])
          .map((e) => DnGrandTotalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headers': headers.map((e) => e.toJson()).toList(),
      'grandtotal': grandtotal.map((e) => e.toJson()).toList(),
    };
  }
}
