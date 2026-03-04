class ReturnDataAPI {
  bool success;
  String data;
  int rowcount;

  ReturnDataAPI({
    required this.success,
    required this.data,
    required this.rowcount,
  });

  factory ReturnDataAPI.fromDatabaseJson(Map<String, dynamic> json) {
    return ReturnDataAPI(
      success: json['success'] ?? false,
      data: json['data']?.toString() ?? '',
      rowcount: json['rowcount'] ?? 0,
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
    "success": success,
    "data": data,
    "rowcount": rowcount,
  };
}
