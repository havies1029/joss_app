import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:equatable/equatable.dart';

class PaymentMethodCariState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool hasError;
  final List<PaymentCategory> categories;
  final String? selectedMethodId;

  const PaymentMethodCariState({
    this.isLoading = false,
    this.isLoaded = false,
    this.hasError = false,
    this.categories = const [],
    this.selectedMethodId,
  });

  PaymentMethodCariState copyWith({
    bool? isLoading,
    bool? isLoaded,
    bool? hasError,
    List<PaymentCategory>? categories,
    String? selectedMethodId,
  }) {
    return PaymentMethodCariState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      hasError: hasError ?? this.hasError,
      categories: categories ?? this.categories,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoaded, hasError, categories, selectedMethodId];
}
