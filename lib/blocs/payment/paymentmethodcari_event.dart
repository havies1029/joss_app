import 'package:equatable/equatable.dart';

abstract class PaymentMethodCariEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentMethodCariLoadEvent extends PaymentMethodCariEvent {}

class PaymentSelectMethodEvent extends PaymentMethodCariEvent {
  final String methodId;

  PaymentSelectMethodEvent(this.methodId);

  @override
  List<Object?> get props => [methodId];
}

class PaymentResetSelectedEvent extends PaymentMethodCariEvent {}
