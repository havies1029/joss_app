import 'package:equatable/equatable.dart';

class ComboMCobApp1Model extends Equatable {
  final String cobIcon;
  final String cobNama;
  final bool isAktif;
  final String mCobApp1Id;
  final int noUrut;

  const ComboMCobApp1Model({
    this.cobIcon = '',
    this.cobNama = '',
    this.isAktif = false,
    this.mCobApp1Id = '',
    this.noUrut = 0,
  });

  factory ComboMCobApp1Model.fromJson(Map<String, dynamic> data) =>
     ComboMCobApp1Model(
      cobIcon: data['cobIcon'],
      cobNama: data['cobNama'],
      isAktif: data['isAktif'],
      mCobApp1Id: data['mCobApp1Id'],
      noUrut: data['noUrut'],
    );

  Map<String, dynamic> toJson() =>
      {  'cobIcon': cobIcon,
      'cobNama': cobNama,
      'isAktif': isAktif,
      'mCobApp1Id': mCobApp1Id,
      'noUrut': noUrut,
    };


  @override
  List<Object> get props => [cobIcon, cobNama, isAktif, mCobApp1Id, noUrut];
}
