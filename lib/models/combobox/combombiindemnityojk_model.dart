import 'package:equatable/equatable.dart';

class ComboMBiindemnityOjkModel extends Equatable {
  final String mbiindemnityojkId;
  final String keterangan;
  final double rateIndex;

  const ComboMBiindemnityOjkModel(
      {this.mbiindemnityojkId = '', this.keterangan = '', this.rateIndex = 0});

  factory ComboMBiindemnityOjkModel.fromJson(Map<String, dynamic> data) =>
      ComboMBiindemnityOjkModel(
          mbiindemnityojkId: data['mbiindemnityojkId'],
          keterangan: data['keterangan'],
          rateIndex: data['rateIndex']);

  Map<String, dynamic> toJson() =>
      {'mbiindemnityojkId': mbiindemnityojkId, 
      'keterangan': keterangan,
      'rateIndex': rateIndex.toString()};

  @override
  List<Object> get props => [mbiindemnityojkId, keterangan, rateIndex];
}
