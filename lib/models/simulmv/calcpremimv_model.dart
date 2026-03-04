
class CalcPremiMvModel {	
	double premiCasco;
	double premiExtCover;
	double premiTotal;	
  bool success;
  String data;

	CalcPremiMvModel({
    required this.premiCasco, 
		required this.premiExtCover, 
    required this.premiTotal, 
    this.success = false, 
    this.data = "",
	});

	factory CalcPremiMvModel.fromJson(Map<String, dynamic> data) {
		return CalcPremiMvModel(			
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiExtCover: double.tryParse(data['premiExtCover'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,			
      success: data['success'], 
      data: data['data'], 
		);

	}

	Map<String, dynamic> toJson() =>
		{      
		'premiCasco': premiCasco.toString(),
		'premiExtCover': premiExtCover.toString(),
		'premiTotal': premiTotal.toString(),
    "success": success,
    "data": data,
		};

}
