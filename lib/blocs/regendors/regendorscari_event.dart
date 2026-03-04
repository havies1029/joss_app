part of 'regendorscari_bloc.dart';

abstract class RegendorsCariEvents extends Equatable {
	const RegendorsCariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegendorsCariEvent extends RegendorsCariEvents {}

class RefreshRegendorsCariEvent extends RegendorsCariEvents {
	final String searchText;

	const RefreshRegendorsCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

