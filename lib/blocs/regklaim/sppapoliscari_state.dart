part of 'sppapoliscari_bloc.dart';

class SppapoliscariState extends Equatable {

	final ListStatus status;
	final List<SppapoliscariModel> items;
	final bool hasReachedMax;
  final String cobKlaimId;
  final String searchText;
  final int hal;

	const SppapoliscariState(
		{this.status = ListStatus.initial,
		this.items = const <SppapoliscariModel>[],
		this.hasReachedMax = false,
		this.cobKlaimId = "",
    this.searchText = "",
    this.hal = 0
		});

	const SppapoliscariState.success(List<SppapoliscariModel> items)
			: this(status: ListStatus.success, items: items);

	const SppapoliscariState.failure() : this(status: ListStatus.failure);

	SppapoliscariState copyWith(
		{List<SppapoliscariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? cobKlaimId, 
    String? searchText,
    int? hal
		}){
		return SppapoliscariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      cobKlaimId: cobKlaimId ?? this.cobKlaimId,
      searchText: searchText ?? this.searchText,
      hal: hal ?? this.hal
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, cobKlaimId, searchText, hal];
}
