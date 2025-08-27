import 'package:joss_app/apis/simulmv/calcpremimv_api.dart';
import 'package:joss_app/models/simulmv/calcpremimv_model.dart';
import 'package:joss_app/models/simulmv/simulmvcrud_model.dart';

class CalcPremiMvRepository {

	Future<CalcPremiMvModel> getCalcPremiMv(SimulmvCrudModel record) async {
		CalcPremiMvAPI api = CalcPremiMvAPI();
		return await api.calcPremiMVAPI(record);
	}
}
