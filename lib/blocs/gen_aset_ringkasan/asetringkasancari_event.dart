part of 'asetringkasancari_bloc.dart';

abstract class AsetRingkasanCariEvents extends Equatable {
	const AsetRingkasanCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetRingkasanCariEvent extends AsetRingkasanCariEvents {}

class RefreshAsetRingkasanCariEvent extends AsetRingkasanCariEvents {
	final String searchText;
  final String statusId;

	const RefreshAsetRingkasanCariEvent({required this.searchText, required this.statusId});

	@override
	List<Object> get props => [searchText, statusId];
}

