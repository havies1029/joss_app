import 'package:equatable/equatable.dart';

class ComboMConveyDetailModel extends Equatable {
  final String mconveydetailId;
  final String detailDesc;
  final double rate;

  const ComboMConveyDetailModel(
      {this.mconveydetailId = '', this.detailDesc = '', this.rate = 0});

  factory ComboMConveyDetailModel.fromJson(Map<String, dynamic> data) =>
      ComboMConveyDetailModel(
          mconveydetailId: data['mconveydetailId'],
          detailDesc: data['detailDesc'],          
          rate: double.tryParse(data['rate'].toString()) ?? 0,);
          

  Map<String, dynamic> toJson() =>
      {'mconveydetailId': mconveydetailId, 'detailDesc': detailDesc, 'rate': rate.toString()};

  @override
  List<Object> get props => [mconveydetailId, detailDesc, rate];
}
