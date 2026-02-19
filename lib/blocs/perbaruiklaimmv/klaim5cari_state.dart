part of 'klaim5cari_bloc.dart';

class Klaim5cariState extends Equatable {

	final ListStatus status;
	final List<Klaim5cariModel> items;
	final bool hasReachedMax;
  final String klaim1Id;
  final String? errorMessage;
  final bool isComplete;

	const Klaim5cariState(
		{this.status = ListStatus.initial,
		this.items = const <Klaim5cariModel>[],
		this.hasReachedMax = false,
    this.klaim1Id = '',
    this.errorMessage,
    this.isComplete = false,
		});

	const Klaim5cariState.success(List<Klaim5cariModel> items)
			: this(status: ListStatus.success, items: items);

	const Klaim5cariState.failure() : this(status: ListStatus.failure);

	Klaim5cariState copyWith(
		{List<Klaim5cariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? klaim1Id,
    String? errorMessage,
    bool? isComplete,
		}){
		return Klaim5cariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      errorMessage: errorMessage ?? this.errorMessage,
      isComplete: isComplete ?? this.isComplete,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, klaim1Id, errorMessage ?? '', isComplete];
}
