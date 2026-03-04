part of 'asetdashboardcari_bloc.dart';

abstract class AsetDashboardCariEvents extends Equatable {
	const AsetDashboardCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetDashboardCariEvent extends AsetDashboardCariEvents {}

class RefreshAsetDashboardCariEvent extends AsetDashboardCariEvents {
  final String cobAppId;  
  const RefreshAsetDashboardCariEvent({required this.cobAppId});

  @override
  List<Object> get props => [cobAppId];
}

