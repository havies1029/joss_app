
class Regmv6FormModel {
	double diskonPersen;
	double premiAdd;
	double premiCasco;
	double premiDiskon;
	double premiNet;
	double premiSubtotal;
	String regmv6Id;
	double rateDasar; // sementara komprehensif
	double rateLoading; // loading
	double rateSrcc; //kerusuhan
	double rateFlood; //banjir
	double rateEq; // gempa bumi
	double rateTerrorism; // terorisme dan sabotase
	double ratePad;
	double rateAw; // bengkel resmi
	double ratePap;
	double biayaPolis;
	double tsi;
	double rateTotal; //total

	Regmv6FormModel({required this.diskonPersen, required this.premiAdd,
		required this.premiCasco, required this.premiDiskon,
		required this.premiNet, required this.premiSubtotal,
		required this.regmv6Id,
		this.rateDasar = 0,
		this.rateLoading = 0,
		this.rateSrcc = 0,
		this.rateFlood = 0,
		this.rateEq = 0,
		this.rateTerrorism = 0,
		this.ratePad = 0,
		this.ratePap = 0,
		this.biayaPolis = 0,
		this.tsi = 0,
		this.rateTotal = 0,
		this.rateAw = 0,
	});

	factory Regmv6FormModel.fromJson(Map<String, dynamic> data) {
		return Regmv6FormModel(
			diskonPersen: double.tryParse(data['diskonPersen'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiDiskon: double.tryParse(data['premiDiskon'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiSubtotal: double.tryParse(data['premiSubtotal'].toString())??0,
			regmv6Id: data['regmv6Id']??'',
			rateDasar: double.tryParse(data['rateDasar'].toString())??0,
			rateLoading: double.tryParse(data['rateLoading'].toString())??0,
			rateSrcc: double.tryParse(data['rateSrcc'].toString())??0,
			rateFlood: double.tryParse(data['rateFlood'].toString())??0,
			rateEq: double.tryParse(data['rateEq'].toString())??0,
			rateTerrorism: double.tryParse(data['rateTerrorism'].toString())??0,
			ratePad: double.tryParse(data['ratePad'].toString())??0,
			ratePap: double.tryParse(data['ratePap'].toString())??0,
			biayaPolis: double.tryParse(data['biayaPolis'].toString())??0,
			tsi: double.tryParse(data['tsi'].toString())??0,
			rateTotal: double.tryParse(data['rateTotal'].toString())??0,
			rateAw: double.tryParse(data['rateAw'].toString())??0,
		);

	}

	Map<String, dynamic> toJson() =>
			{'diskonPersen': diskonPersen.toString(),
				'premiAdd': premiAdd.toString(),
				'premiCasco': premiCasco.toString(),
				'premiDiskon': premiDiskon.toString(),
				'premiNet': premiNet.toString(),
				'premiSubtotal': premiSubtotal.toString(),
				'regmv6Id': regmv6Id,
				'rateDasar': rateDasar.toString(),
				'rateLoading': rateLoading.toString(),
				'rateSrcc': rateSrcc.toString(),
				'rateFlood': rateFlood.toString(),
				'rateEq': rateEq.toString(),
				'rateTerrorism': rateTerrorism.toString(),
				'ratePad': ratePad.toString(),
				'ratePap': ratePap.toString(),
				'biayaPolis': biayaPolis.toString(),
				'tsi': tsi.toString(),
				'rateTotal': rateTotal.toString(),
				'rateAw': rateAw.toString(),
			};

}
