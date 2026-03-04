import 'package:joss_app/models/payment/paymentmethoditem_model.dart';

class PaymentCategory {
  final String categoryId;
  final String categoryName;
  final int sortOrder;
  final List<PaymentMethodItem> items;

  PaymentCategory({
    required this.categoryId,
    required this.categoryName,
    required this.sortOrder,
    required this.items,
  });

  factory PaymentCategory.fromJson(Map<String, dynamic> json) {
    return PaymentCategory(
      categoryId: json['CategoryId'] ?? '',
      categoryName: json['CategoryName'] ?? '',
      sortOrder: json['SortOrder'] ?? 0,
      items: (json['Items'] as List<dynamic>? ?? [])
          .map((e) => PaymentMethodItem.fromJson(e))
          .toList(),
    );
  }
}