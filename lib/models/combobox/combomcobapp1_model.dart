import 'package:equatable/equatable.dart';

class ComboMCobApp1Model extends Equatable {
  final String mCobApp1Id;
  final String cobNama;

  const ComboMCobApp1Model({this.mCobApp1Id='', this.cobNama=''});

  factory ComboMCobApp1Model.fromJson(Map<String, dynamic> data) =>
      ComboMCobApp1Model(
        mCobApp1Id: data['mCobApp1Id'],
        cobNama: data['cobNama'],
      );

  Map<String, dynamic> toJson() =>
      {'mCobApp1Id': mCobApp1Id,
        'cobNama': cobNama,};

  @override
  List<Object> get props => [mCobApp1Id, cobNama];
}
