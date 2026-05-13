part of 'mlayanan1cari_bloc.dart';

abstract class Mlayanan1CariEvents extends Equatable {
	const Mlayanan1CariEvents();

	@override
	List<Object> get props => [];
}

class FetchMlayanan1CariEvent extends Mlayanan1CariEvents {
  final String mlayanan1Id;

  const FetchMlayanan1CariEvent({required this.mlayanan1Id}); 

  @override
  List<Object> get props => [mlayanan1Id];
}

class RefreshMlayanan1CariEvent extends Mlayanan1CariEvents {}

