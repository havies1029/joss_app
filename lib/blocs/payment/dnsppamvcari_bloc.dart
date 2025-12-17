import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/dnsppamvcari_model.dart';
import 'package:joss_app/repositories/payment/dnsppamvcari_repository.dart';

part 'dnsppamvcari_event.dart';
part 'dnsppamvcari_state.dart';

class DnsppamvCariBloc extends Bloc<DnsppamvCariEvents, DnsppamvCariState> {
	DnsppamvCariBloc() : super(const DnsppamvCariState()) {
		on<FetchDnsppamvCariEvent>(onFetchDnsppamvCari);
		on<RefreshDnsppamvCariEvent>(onRefreshDnsppamvCari);
	}

Future<void> onRefreshDnsppamvCari(
		RefreshDnsppamvCariEvent event, Emitter<DnsppamvCariState> emit) async {
	emit(const DnsppamvCariState());
  emit(state.copyWith(
    sppa1Id: event.sppa1Id,
    searchText: event.searchText,
    hal: 0,
  ));

	add(FetchDnsppamvCariEvent());
}

Future<void> onFetchDnsppamvCari(
		FetchDnsppamvCariEvent event, Emitter<DnsppamvCariState> emit) async {
	if (state.hasReachedMax) return;

	DnsppamvCariRepository repo = DnsppamvCariRepository();
	if (state.status == ListStatus.initial) {
		List<DnsppamvCariModel> items = await repo.getDnsppamvCari(state.sppa1Id, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<DnsppamvCariModel> items = await repo.getDnsppamvCari(state.sppa1Id, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<DnsppamvCariModel> dnsppamvCari = List.of(state.items)..addAll(items);

		final result = dnsppamvCari
			.whereWithIndex((e, index) =>
				dnsppamvCari.indexWhere((e2) => e2.dn1Id == e.dn1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}

	}
}