import 'package:equatable/equatable.dart';

class ComboRKodeposModel extends Equatable {
  final String rkodeposId;
  final String kodeposNo;
  final String wilayah;

  const ComboRKodeposModel({this.rkodeposId = '', this.kodeposNo = '', this.wilayah = ''});

  factory ComboRKodeposModel.fromJson(Map<String, dynamic> data) =>
      ComboRKodeposModel(
        rkodeposId: data['rkodeposId'],
        kodeposNo: data['kodeposNo'],
        wilayah: data['wilayah'],
      );

  Map<String, dynamic> toJson() => {
        'rkodeposId': rkodeposId,
        'kodeposNo': kodeposNo,
        'wilayah': wilayah,
      };

  @override
  List<Object> get props => [rkodeposId, kodeposNo, wilayah];
}
