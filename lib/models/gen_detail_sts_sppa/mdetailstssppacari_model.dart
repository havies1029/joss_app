class MDetailStsSppaCariModel {
  String mdetailstssppaId;
  String statusNama;
  int noUrut;

  MDetailStsSppaCariModel({
    required this.mdetailstssppaId,
    required this.statusNama,
    required this.noUrut,
  });

  factory MDetailStsSppaCariModel.fromJson(Map<String, dynamic> data) {
    return MDetailStsSppaCariModel(
      mdetailstssppaId: data['mdetailstssppaId'] ?? '',
      statusNama: data['statusNama'] ?? '',
      noUrut: int.tryParse(data['noUrut'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'mdetailstssppaId': mdetailstssppaId,
        'statusNama': statusNama,
        'noUrut': noUrut.toString(),
      };
}
