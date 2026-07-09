import 'package:equatable/equatable.dart';

class ComboMReferralModel extends Equatable {
  final String mreferralId;
  final String kodeUnik;
  final String namaMarketing;

  const ComboMReferralModel({
    this.mreferralId = '',
    this.kodeUnik = '',
    this.namaMarketing = '',
  });

  factory ComboMReferralModel.fromJson(Map<String, dynamic> data) =>
      ComboMReferralModel(
        mreferralId: data['mreferralId'],
        kodeUnik: data['kodeUnik'],
        namaMarketing: data['namaMarketing'],
      );

  Map<String, dynamic> toJson() => {
        'mreferralId': mreferralId,
        'kodeUnik': kodeUnik,
        'namaMarketing': namaMarketing,
      };

  @override
  List<Object> get props => [mreferralId, kodeUnik, namaMarketing];
}
