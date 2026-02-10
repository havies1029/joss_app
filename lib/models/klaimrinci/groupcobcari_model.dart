import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';

class GroupcobCariModel {
  String cobId;
  String cobNama;
  List<KlaimdetailCariModel> details;

  GroupcobCariModel({
    required this.cobId,
    required this.cobNama,
    required this.details,
  });

  factory GroupcobCariModel.fromJson(Map<String, dynamic> data) {
    final rawDetails = data['details'];

    final parsedDetails = (rawDetails is List)
        ? rawDetails
            .map((e) => KlaimdetailCariModel.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ))
            .toList()
        : <KlaimdetailCariModel>[];

    // opsional: isi cobNama di setiap detail kalau kosong
    for (final d in parsedDetails) {
      if (d.cobNama.isEmpty) d.cobNama = data['cobNama'] ?? '';
    }

    return GroupcobCariModel(
      cobId: data['cobId'] ?? '',
      cobNama: data['cobNama'] ?? '',
      details: parsedDetails,
    );
  }

  Map<String, dynamic> toJson() => {
        'cobId': cobId,
        'cobNama': cobNama,
        'details': details.map((d) => d.toJson()).toList(),
      };
}
