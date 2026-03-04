class PaymentMethodItem {
  final String methodId;
  final String categoryId;
  final String title;
  final int sortOrder;
  final String iconId;
  final String iconUrl;

  PaymentMethodItem({
    required this.methodId,
    required this.categoryId,
    required this.title,
    required this.sortOrder,
    required this.iconId,
    required this.iconUrl,
  });

  factory PaymentMethodItem.fromJson(Map<String, dynamic> json) {
    return PaymentMethodItem(
      methodId: json['MethodId'] ?? '',
      categoryId: json['CategoryId'] ?? '',
      title: json['Title'] ?? '',
      sortOrder: json['SortOrder'] ?? 0,
      iconId: json['IconId'] ?? '',
      iconUrl: json['IconUrl'] ?? '',
    );
  }
}