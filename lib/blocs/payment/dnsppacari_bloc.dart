
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
			RefreshDnsppaCariEvent event,
			Emitter<DnsppaCariState> emit,
			) async {
		emit(
			DnsppaCariState(
				listcobId: event.listcobId,
				currId: event.currId,
				searchText: event.searchText ?? "",
				hal: 0,
				status: ListStatus.initial,
				items: const [],
				hasReachedMax: false,
			),
		);

		add(FetchDnsppaCariEvent());
	}

	Future<void> onFetchDnsppaCari(
			FetchDnsppaCariEvent event,
			Emitter<DnsppaCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = DnsppaCariRepository();

		try {
			if (state.status == ListStatus.initial) {
				final items = await repo.getDnsppaCari(
					state.listcobId,
					state.currId,
					state.searchText,
					state.hal,
				);

				emit(
					state.copyWith(
						items: items,
						hasReachedMax: items.isEmpty,
						status: ListStatus.success,
						hal: 1,
					),
				);
				return;
			}

			final items = await repo.getDnsppaCari(
				state.listcobId,
				state.currId,
				state.searchText,
				state.hal + 1,
			);

			if (items.isEmpty) {
				emit(state.copyWith(hasReachedMax: true));
				return;
			}

			final merged = List<DnsppaCariModel>.of(state.items)..addAll(items);

			final result = merged
					.whereWithIndex(
						(e, index) => merged.indexWhere((e2) => e2.dn1Id == e.dn1Id) == index,
			)
					.toList();

			emit(
				state.copyWith(
					items: result,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: state.hal + 1,
				),
			);
		} catch (_) {
			emit(state.copyWith(status: ListStatus.failure));
		}
	}
}