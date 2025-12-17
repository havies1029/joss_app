part of 'dnsppacari_bloc.dart';

abstract class DnsppaCariEvents extends Equatable {
	const DnsppaCariEvents();

	@override
	List<Object> get props => [];
}

class FetchDnsppaCariEvent extends DnsppaCariEvents {}

class RefreshDnsppaCariEvent extends DnsppaCariEvents {
  final String listcobId;
  final String currId;
  final String searchText;
  const RefreshDnsppaCariEvent(
    {
      this.listcobId = "",
      this.currId = "",
      this.searchText = "",
    });
  @override
  List<Object> get props => [listcobId, currId, searchText];
}

