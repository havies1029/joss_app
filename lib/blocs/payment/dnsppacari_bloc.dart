
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';
import 'package:joss_app/repositories/payment/dnsppacari_repository.dart';

part 'dnsppacari_event.dart';
part 'dnsppacari_state.dart';

class DnsppaCariBloc extends Bloc<DnsppaCariEvents, DnsppaCariState> {
	DnsppaCariBloc() : super(const DnsppaCariState()) {
		on<FetchDnsppaCariEvent>(onFetchDnsppaCari);
		on<RefreshDnsppaCariEvent>(onRefreshDnsppaCari);
	}

Future<void> onRefreshDnsppaCari(
		RefreshDnsppaCariEvent event, Emitter<DnsppaCariState> emit) async {
	emit(const DnsppaCariState());

  emit(state.copyWith(
    listcobId: event.listcobId,
    currId: event.currId,
    searchText: event.searchText,
    hal: 0,
  ));
	add(FetchDnsppaCariEvent());
}

Future<void> onFetchDnsppaCari(
		FetchDnsppaCariEvent event, Emitter<DnsppaCariState> emit) async {
	if (state.hasReachedMax) return;

	DnsppaCariRepository repo = DnsppaCariRepository();
	if (state.status == ListStatus.initial) {
		List<DnsppaCariModel> items = await repo.getDnsppaCari(state.listcobId, state.currId, state.searchText, state.hal);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1
			));
	}
	List<DnsppaCariModel> items = await repo.getDnsppaCari(state.listcobId, state.currId, state.searchText, state.hal + 1);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<DnsppaCariModel> dnsppaCari = List.of(state.items)..addAll(items);

		final result = dnsppaCari
			.whereWithIndex((e, index) =>
				dnsppaCari.indexWhere((e2) => e2.dn1Id == e.dn1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1
			));
		}

	}
}