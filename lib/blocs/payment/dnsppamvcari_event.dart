part of 'dnsppamvcari_bloc.dart';

abstract class DnsppamvCariEvents extends Equatable {
	const DnsppamvCariEvents();

	@override
	List<Object> get props => [];
}

class FetchDnsppamvCariEvent extends DnsppamvCariEvents {}

class RefreshDnsppamvCariEvent extends DnsppamvCariEvents {
  
	final String sppa1Id;
	final String searchText;

	const RefreshDnsppamvCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

