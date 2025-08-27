
class CalcpremiparModel {
	String errordesc;
	bool issuccess;
	double premibi;
	double premieqvet;
	double premiflexas;
	double preminet;
	double premiothers;
	double premirsmdcc;
	double premitotal;
	double premitsfwd;

	CalcpremiparModel({required this.errordesc, required this.issuccess, 
		this.premibi = 0, this.premieqvet = 0, 
		this.premiflexas = 0, this.preminet = 0, 
		this.premiothers = 0, this.premirsmdcc = 0, 
		this.premitotal = 0, this.premitsfwd = 0});

	factory CalcpremiparModel.fromJson(Map<String, dynamic> data) {
		return CalcpremiparModel(
			errordesc: data['errordesc']??'',
			issuccess: data['issuccess']??false,
			premibi: double.tryParse(data['premibi'].toString())??0,
			premieqvet: double.tryParse(data['premieqvet'].toString())??0,
			premiflexas: double.tryParse(data['premiflexas'].toString())??0,
			preminet: double.tryParse(data['preminet'].toString())??0,
			premiothers: double.tryParse(data['premiothers'].toString())??0,
			premirsmdcc: double.tryParse(data['premirsmdcc'].toString())??0,
			premitotal: double.tryParse(data['premitotal'].toString())??0,
			premitsfwd: double.tryParse(data['premitsfwd'].toString())??0
		);

	}

	Map<String, dynamic> toJson() =>
		{'errordesc': errordesc,
		'issuccess': issuccess,
		'premibi': premibi.toString(),
		'premieqvet': premieqvet.toString(),
		'premiflexas': premiflexas.toString(),
		'preminet': preminet.toString(),
		'premiothers': premiothers.toString(),
		'premirsmdcc': premirsmdcc.toString(),
		'premitotal': premitotal.toString(),
		'premitsfwd': premitsfwd.toString()};

}
