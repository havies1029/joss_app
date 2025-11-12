import 'package:flutter_bloc/flutter_bloc.dart';

class Calmv2IdCubit extends Cubit<String?> {
  Calmv2IdCubit() : super(null);

  void setCalmv2Id(String id) => emit(id);
  void clear() => emit(null);
}
