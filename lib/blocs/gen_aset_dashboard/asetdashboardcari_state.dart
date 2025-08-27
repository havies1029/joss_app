part of 'asetdashboardcari_bloc.dart';

class AsetDashboardCariState extends Equatable {

	final ListStatus status;
	final List<AsetDashboardCariModel> items;
	final bool hasReachedMax;
  final String cobAppId;
	const AsetDashboardCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetDashboardCariModel>[],
		this.hasReachedMax = false,
		this.cobAppId = "",
		});

	const AsetDashboardCariState.success(List<AsetDashboardCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetDashboardCariState.failure() : this(status: ListStatus.failure);

	AsetDashboardCariState copyWith(
		{List<AsetDashboardCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? cobAppId,
		}){
		return AsetDashboardCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			cobAppId: cobAppId ?? this.cobAppId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, cobAppId];
}
