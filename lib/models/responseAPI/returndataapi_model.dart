class ReturnDataAPI {
  bool success = false;
  String data = "";
  int rowcount = 0;

  ReturnDataAPI(
      {required this.success, required this.data, required this.rowcount});

  factory ReturnDataAPI.fromDatabaseJson(Map<String, dynamic> data) =>
      ReturnDataAPI(
        success: data['success'], 
        data: data['data'], 
        rowcount: data['rowcount']);

  Map<String, dynamic> toDatabaseJson() => {
    "success": success,
    "data": data,
    "rowcount": rowcount
  };
}
