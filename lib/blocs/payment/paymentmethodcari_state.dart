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

  static const _unset = Object();

  PaymentMethodCariState copyWith({
    bool? isLoading,
    bool? isLoaded,
    bool? hasError,
    List<PaymentCategory>? categories,
    Object? selectedMethodId = _unset,
  }) {
    return PaymentMethodCariState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      hasError: hasError ?? this.hasError,
      categories: categories ?? this.categories,
      selectedMethodId: selectedMethodId == _unset
          ? this.selectedMethodId
          : selectedMethodId as String?,
    );
  }

  String? get selectedMethodName {
    if (selectedMethodId == null) return null;
    for (final c in categories) {
      for (final item in c.items) {
        if (item.methodId == selectedMethodId) {
          return item.title;
        }
      }
    }
    return null;
  }

  String? get selectedCategoryName {
    if (selectedMethodId == null) return null;

    for (final c in categories) {
      final found = c.items.any((item) => item.methodId == selectedMethodId);
      if (found) return c.categoryName;
    }

    return null;
  }

  PaymentCategory? get selectedCategory {
    if (selectedMethodId == null) return null;

    for (final c in categories) {
      if (c.items.any((item) => item.methodId == selectedMethodId)) {
        return c;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoaded,
    hasError,
    categories,
    selectedMethodId,
  ];
}