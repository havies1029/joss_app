import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomePageActive()) {
    on<HomePageActiveEvent>((event, emit) => emit(HomePageActive()));
  }
}
