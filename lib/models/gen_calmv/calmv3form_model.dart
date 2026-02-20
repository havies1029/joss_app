
class Calmv3FormModel {
	String calmv3Id;
	double diskonPersen;
	double premiAdd;
	double premiCasco;
	double premiDiskon;
	double premiNet;
	double premiSubtotal;
	double rateDasar;
	double rateLoading;
	double rateSrcc;
	double rateFlood;
	double rateEq;
	double rateTerrorism;
	double ratePad;
	double ratePap;
	double biayaPolis;

	Calmv3FormModel({required this.calmv3Id, required this.diskonPersen,
		required this.premiAdd, required this.premiCasco,
		required this.premiDiskon, required this.premiNet,
		required this.premiSubtotal,
		this.rateDasar = 0,
		this.rateLoading = 0,
		this.rateSrcc = 0,
		this.rateFlood = 0,
		this.rateEq = 0,
		this.rateTerrorism = 0,
		this.ratePad = 0,
		this.ratePap = 0,
		this.biayaPolis = 0,});

	factory Calmv3FormModel.fromJson(Map<String, dynamic> data) {
		return Calmv3FormModel(
			calmv3Id: data['calmv3Id']??'',
			diskonPersen: double.tryParse(data['diskonPersen'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiDiskon: double.tryParse(data['premiDiskon'].toString())??0,
			premiNet: double.tryParse(data['premiNet'].toString())??0,
			premiSubtotal: double.tryParse(data['premiSubtotal'].toString())??0,
			rateDasar: double.tryParse(data['rateDasar'].toString())??0,
			rateLoading: double.tryParse(data['rateLoading'].toString())??0,
			rateSrcc: double.tryParse(data['rateSrcc'].toString())??0,
			rateFlood: double.tryParse(data['rateFlood'].toString())??0,
			rateEq: double.tryParse(data['rateEq'].toString())??0,
			rateTerrorism: double.tryParse(data['rateTerrorism'].toString())??0,
			ratePad: double.tryParse(data['ratePad'].toString())??0,
			ratePap: double.tryParse(data['ratePap'].toString())??0,
			biayaPolis: double.tryParse(data['biayaPolis'].toString())??0,
		);

	}

	Map<String, dynamic> toJson() =>
			{'calmv3Id': calmv3Id,
				'diskonPersen': diskonPersen.toString(),
				'premiAdd': premiAdd.toString(),
				'premiCasco': premiCasco.toString(),
				'premiDiskon': premiDiskon.toString(),
				'premiNet': premiNet.toString(),
				'premiSubtotal': premiSubtotal.toString(),
				'rateDasar': rateDasar.toString(),
				'rateLoading': rateLoading.toString(),
				'rateSrcc': rateSrcc.toString(),
				'rateFlood': rateFlood.toString(),
				'rateEq': rateEq.toString(),
				'rateTerrorism': rateTerrorism.toString(),
				'ratePad': ratePad.toString(),
				'ratePap': ratePap.toString(),
				'biayaPolis': biayaPolis.toString(),
			};

	factory Calmv3FormModel.empty() {
		return Calmv3FormModel(
			calmv3Id: '',
			diskonPersen: 0,
			premiAdd: 0,
			premiCasco: 0,
			premiDiskon: 0,
			premiNet: 0,
			premiSubtotal: 0,
			rateDasar: 0,
			rateLoading: 0,
			rateSrcc: 0,
			rateFlood: 0,
			rateEq: 0,
			rateTerrorism: 0,
			ratePad: 0,
			ratePap: 0,
			biayaPolis: 0,
		);
	}
}
